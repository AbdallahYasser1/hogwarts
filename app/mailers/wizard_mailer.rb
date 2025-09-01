class WizardMailer < ApplicationMailer
  default from: "hogwarts@school.com"

  def welcome_email(wizard)
    @wizard = wizard
    mail(
      to: @wizard.email,
      subject: "Welcome to Hogwarts!"
    )
  end
end
