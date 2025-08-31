module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_standard_error
  end

  private

  def handle_standard_error(exception)
    flash[:alert] = "An unexpected error occurred: #{exception.message}"
    redirect_to request.referrer || root_path
  end
end
