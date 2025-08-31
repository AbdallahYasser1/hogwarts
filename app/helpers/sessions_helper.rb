module SessionsHelper
  def current_wizard
    @current_wizard ||= AuthenticationService.new(session, cookies).current_wizard
  end

  def wizard_signed_in?
    AuthenticationService.new(session, cookies).wizard_signed_in?
  end
end
