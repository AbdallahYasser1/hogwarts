require "test_helper"

class WizardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @wizard = wizards(:hermione)
    @admin = wizards(:mcgonagall)
    @other_wizard = wizards(:harry)
    sign_in @wizard
  end

  test "should show wizard" do
    get wizard_url(@wizard)
    assert_response :success
    assert_select "h1", /Hermione Granger/
  end

  test "should update permitted fields as normal wizard" do
    patch wizard_url(@wizard), params: { wizard: { name: "Hermione the Wise", bio: "Even brighter." } }
    assert_redirected_to wizard_path(@wizard)
    @wizard.reload
    assert_equal "Hermione the Wise", @wizard.name
    assert_equal "Even brighter.", @wizard.bio
  end

  test "should not permit email or house for non-admin" do
    patch wizard_url(@wizard), params: { wizard: { email: "new@hogwarts.com", hogwarts_house: "Slytherin" } }
    @wizard.reload
    assert_not_equal "new@hogwarts.com", @wizard.email
    assert_not_equal "Slytherin", @wizard.hogwarts_house
  end

  test "should permit email and house for admin" do
    sign_out @wizard
    sign_in @admin
    patch wizard_url(@other_wizard), params: { wizard: { email: "new@hogwarts.com", hogwarts_house: "Slytherin" } }
    @other_wizard.reload
    assert_equal "new@hogwarts.com", @other_wizard.email
    assert_equal "slytherin", @other_wizard.hogwarts_house
  end

  test "should not update with invalid password" do
    patch wizard_url(@wizard), params: { wizard: { password: "short" } }
    assert_response :unprocessable_entity
  end

  test "should forbid update if not authorized" do
    patch wizard_url(@admin), params: { wizard: { name: "Fake" } }
    assert_response :redirect
    assert_equal "You are not authorized to perform this action.", flash[:alert]
  end
end
