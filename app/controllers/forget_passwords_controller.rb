class ForgetPasswordsController < ApplicationController
  before_action :find_wizard_by_token, only: [ :edit, :update ]
  before_action :validate_token_and_time, only: [ :edit, :update ]

  def new
  end

  def create
    service = ForgetPasswordService.new(params[:email])
    if service.send_reset_instructions
      flash[:info] = "Reset instructions sent to your email."
      redirect_to login_path
    else
      flash.now[:alert] = "Email not found."
      render :new
    end
  end

  def edit
  end

  def update
    if @wizard.update(password: params[:password], reset_password_token: nil)
      flash[:info] = "Password has been reset. You can now log in."
      redirect_to login_path
    else
      flash.now[:warning] = @wizard.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_content
    end
  end

  private

  def find_wizard_by_token
    @wizard = Wizard.find_by(reset_password_token: params[:token])
  end

  def validate_token_and_time
    unless @wizard && @wizard.reset_password_sent_at > 2.hours.ago
      flash[:danger] = "Token expired or invalid"
      redirect_to forgot_password_path
    end
  end
end
