class RegistrationsController < ApplicationController
  def new
    @wizard = Wizard.new
  end

  def create
    @wizard = RegistrationService.new(wizard_params).register
    if @wizard.persisted?
      flash[:info] = "Registration successful! Check your email for instructions."
      redirect_to landing_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def wizard_params
    params.require(:wizard).permit(:name, :email, :password, :date_of_birth, :bio, :muggle_relatives)
  end
end
