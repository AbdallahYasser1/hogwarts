module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_standard_error
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  end

  private

  def handle_standard_error(exception)
    flash[:alert] = "An unexpected error occurred: #{exception.message}"
    redirect_to request.referrer || root_path
  end
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
