class WizardsController < ApplicationController
  before_action :set_wizard, only: [ :show, :edit, :update, :edit_password ]


  def index
    @wizards = Wizard.order(:name).page(params[:page]).per(10)
  end

  def show
  end

  def edit
  end

  def edit_password
  end
  def update
    authorize @wizard
    if @wizard.update(update_params)
        redirect_to wizard_path(@wizard), notice: "Wizard updated successfully."
    else
      flash.now[:alert] = @wizard.errors.full_messages.join(", ")
      if params[:wizard][:password].present?
        render :edit_password, status: :unprocessable_entity
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end


  private

  def set_wizard
    @wizard = if params[:id].present? && params[:id].to_i != current_wizard.id
      Wizard.find(params[:id])
    else
      current_wizard
    end
  end
  def update_params
    permitted = [ :name, :date_of_birth, :bio, :muggle_relatives, :avatar, :password, :password_confirmation ]
    permitted << :email << :hogwarts_house if current_wizard.is_admin?
    params.require(:wizard).permit(permitted)
  end
end
