class WizardMailer < ApplicationMailer
  default from: "hogwarts@school.com"

  def welcome_email(wizard)
    @wizard = wizard
    mail(
      to: @wizard.email,
      subject: "Welcome to Hogwarts!"
    )
  end

  def reset_password_email(wizard)
    @wizard = wizard
    mail(to: @wizard.email, subject: "Reset your Hogwarts password")
  end
end
