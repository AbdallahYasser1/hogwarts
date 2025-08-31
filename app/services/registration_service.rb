class RegistrationService
  def initialize(params)
    @params = params
  end

  def register
    wizard = Wizard.new(@params)
    wizard.save
    wizard
  end
end
