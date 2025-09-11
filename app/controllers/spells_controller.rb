class SpellsController < ApplicationController
  before_action :set_wizard
  before_action :set_spell, only: [ :show, :edit, :update, :destroy ]

  def index
    @pagy, @spells = pagy(@wizard.spells.order(:name))
  end

  def show
  end

  def new
    @spell = @wizard.spells.new
    authorize @spell
  end

  def create
    @spell = @wizard.spells.new(spell_params)
    authorize @spell
    if @spell.save
      redirect_to wizard_spell_path(@wizard, @spell), notice: "Spell created successfully."
    else
      flash.now[:alert] = @wizard.errors.full_messages.join(", ")
      render :new, status: :unprocessable_content
    end
  end

  def edit
    authorize @spell
  end

  def update
    authorize @spell
    if @spell.update(spell_params)
      redirect_to wizard_spell_path(@wizard, @spell), notice: "Spell updated successfully."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @spell
    @spell.destroy
    redirect_to wizard_spells_path(@wizard), notice: "Spell deleted."
  end

  private
  def set_wizard
    @wizard = if params[:wizard_id].present? && params[:wizard_id].to_i != current_wizard.id
      Wizard.find(params[:wizard_id])
    else
      current_wizard
    end
  end
  def set_spell
    @spell = Spell.find(params[:id])
  end

  def spell_params
    params.require(:spell).permit(:name, :description)
  end
end
