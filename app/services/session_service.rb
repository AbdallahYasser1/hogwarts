class SessionService
  def initialize(params, cookies, session)
    @params = params
    @cookies = cookies
    @session = session
  end

  def login
    wizard = Wizard.find_by(email: @params[:email])
    if wizard && wizard.authenticate(@params[:password])
      @session[:wizard_id] = wizard.id
      if @params[:remember_me] == "1"
        wizard.remember
        @cookies.permanent.signed[:wizard_id] = wizard.id
        @cookies.permanent[:remember_token] = wizard.remember_token
      end
      wizard
    else
      nil
    end
  end

  def logout(current_wizard)
    if current_wizard
      current_wizard.forget
    end
    @session[:wizard_id] = nil
    @cookies.delete(:wizard_id)
    @cookies.delete(:remember_token)
  end
end
