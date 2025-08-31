require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_registration_url
    assert_response :success
  end

  test "should create wizard and enqueue welcome email via model callback" do
    assert_enqueued_emails 1 do
      assert_difference("Wizard.count", 1) do
        post registrations_url, params: {
          wizard: {
            name: "Hogwarts User",
            email: "user@hogwarts.com",
            password: "Magic123",
            date_of_birth: "1980-07-31",
            bio: "The boy who dead.",
            muggle_relatives: false
          }
        }
      end
    end
  wizard = Wizard.last
  assert_equal "Hogwarts User", wizard.name
  assert_redirected_to landing_path
  end
  test "should not create wizard and redirect to registration page on validation error" do
    assert_no_difference("Wizard.count") do
      post registrations_url, params: {
        wizard: {
          name: "",
          email: "invalid",
          password: "123",
          date_of_birth: "",
          bio: "",
          muggle_relatives: false
        }
      }
    end
    assert_redirected_to registrations_url, status: :unprocessable_content
  end
end
