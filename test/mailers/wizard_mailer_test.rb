require "test_helper"

class WizardMailerTest < ActionMailer::TestCase
  test "welcome_email" do
    wizard = wizards(:hermione)
    email = WizardMailer.welcome_email(wizard).deliver_now
    assert_equal [ wizard.email ], email.to
    assert_match(/Welcome to Hogwarts/, email.body.encoded)
  end
end
