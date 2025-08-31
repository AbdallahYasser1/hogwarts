class AuthenticationService
  def initialize(session, cookies)
    @session = session
    @cookies = cookies
  end

  def current_wizard
    if @session[:wizard_id]
      @current_wizard ||= Wizard.find_by(id: @session[:wizard_id])
    elsif @cookies.signed[:wizard_id]
      wizard = Wizard.find_by(id: @cookies.signed[:wizard_id])
      if wizard && wizard.authenticated?(@cookies[:remember_token])
        @session[:wizard_id] = wizard.id
        @current_wizard = wizard
      end
    end
    @current_wizard
  end

  def wizard_signed_in?
    !!current_wizard
  end
end
