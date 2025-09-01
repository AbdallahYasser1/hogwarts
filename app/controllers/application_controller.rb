class ApplicationController < ActionController::Base
  # include ErrorHandler
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_wizard!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :date_of_birth, :bio, :muggle_relatives ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :date_of_birth, :bio, :muggle_relatives ])
  end
end
