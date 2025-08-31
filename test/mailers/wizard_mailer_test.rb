require "test_helper"

class WizardMailerTest < ActionMailer::TestCase
  test "welcome_email" do
    wizard = Wizard.create!(
      name: "Ron Weasley",
      email: "ron@hogwarts.com",
      password: "RedHair1",
      date_of_birth: "1980-03-01",
      bio: "Loyal friend.",
      muggle_relatives: true,
      hogwarts_house: "Gryffindor"
    )
    email = WizardMailer.welcome_email(wizard).deliver_now
    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal [ wizard.email ], email.to
  assert_match(/Welcome to Hogwarts/, email.body.encoded)
  end
end
