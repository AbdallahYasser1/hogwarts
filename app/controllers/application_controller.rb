class ApplicationController < ActionController::Base
  # include ErrorHandler
  include Pundit::Authorization
  allow_browser versions: :modern
  before_action :authenticate_wizard!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    home_path
  end

  def pundit_user
    current_wizard
  end
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :date_of_birth, :bio, :muggle_relatives ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :date_of_birth, :bio, :muggle_relatives ])
  end
end
