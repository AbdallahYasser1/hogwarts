require "test_helper"

class PasswordsFlowTest < ActionDispatch::IntegrationTest
  def setup
    @wizard=wizards(:harry)
  end

  test "request password reset and reset password" do
    # Request password reset
    post wizard_password_path, params: { wizard: { email: @wizard.email } }
    assert_response :redirect
    follow_redirect!
    assert_match(/You will receive an email/, response.body)

    # Get the reset token from the email
    mail = ActionMailer::Base.deliveries.last
    assert_equal [ @wizard.email ], mail.to
    token = mail.body.encoded.match(/reset_password_token=([^\s"]+)/)[1]

    # Visit password reset page
    get edit_wizard_password_path(reset_password_token: token)
    assert_response :success
    assert_select "form"

    # Submit new password
    put wizard_password_path, params: {
      wizard: {
        reset_password_token: token,
        password: "NewMagic123",
        password_confirmation: "NewMagic123"
      }
    }
    assert_response :redirect
    follow_redirect!
    assert_match(/Your password has been changed successfully/, response.body)
  end
end
