class WizardsController < ApplicationController
  before_action :set_wizard, only: [ :show, :edit, :update, :edit_password, :follow, :unfollow, :followers, :following ]

  def index
    @pagy, @wizards = pagy(
      Wizard.order(:name).includes(:followers, :following, avatar_attachment: :blob)
    )
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
  def follow
    current_wizard.follow(@wizard)
    redirect_to wizard_path(@wizard), notice: "You are now following #{@wizard.name}."
  end

  def unfollow
    current_wizard.unfollow(@wizard)
    redirect_to wizard_path(@wizard), notice: "You have unfollowed #{@wizard.name}."
  end

  def followers
    @wizard = Wizard.find(params[:id])
    @pagy, @followers = pagy(@wizard.followers.includes(avatar_attachment: :blob))
  end

  def following
    @wizard = Wizard.find(params[:id])
    @pagy, @following = pagy(@wizard.following.includes(avatar_attachment: :blob))
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
