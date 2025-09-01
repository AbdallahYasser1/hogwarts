class ForgetPasswordService
  def initialize(email)
    @wizard = Wizard.find_by(email: email)
  end

  def send_reset_instructions
    return false unless @wizard
    @wizard.send_reset_password_email
  true
  end
end
