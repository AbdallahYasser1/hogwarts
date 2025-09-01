require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @wizard = wizards(:harry)
  end

  test "should get login page" do
    get new_wizard_session_path
    assert_response :success
    assert_select "form"
  end

  test "should login with valid credentials" do
    post wizard_session_path, params: { wizard: { email: @wizard.email, password: "Potter007" } }
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a", text: "Welcome, #{ @wizard.name }"
  end

  test "should not login with invalid credentials" do
    post wizard_session_path, params: { wizard: { email: @wizard.email, password: "wrongpassword" } }
    assert_select ".alert", text: /Invalid Email or password/
  end

  test "should logout" do
    post wizard_session_path, params: { wizard: { email: @wizard.email, password: "Potter007" } }
    delete destroy_wizard_session_path
    assert_redirected_to root_path
  end

  test "should remember wizard when remember_me is checked" do
    post wizard_session_path, params: { wizard: { email: @wizard.email, password: "Potter007", remember_me: "1" } }
    assert_not_nil cookies["remember_wizard_token"]
  end

  test "should not remember wizard when remember_me is not checked" do
    post wizard_session_path, params: { wizard: { email: @wizard.email, password: "Potter007", remember_me: "0" } }
    assert_nil cookies["remember_wizard_token"]
  end
end
