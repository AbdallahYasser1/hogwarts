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
            name: "Harry Potter",
            email: "harry@hogwarts.com",
            password: "Magic123",
            date_of_birth: "1980-07-31",
            bio: "The boy who lived.",
            muggle_relatives: false
          }
        }
      end
    end
    wizard = Wizard.last
    assert_equal "Harry Potter", wizard.name
  end
end
