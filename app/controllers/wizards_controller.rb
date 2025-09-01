class WizardsController < ApplicationController
  def show
    @wizard = Wizard.find(params[:id])
  end

  def index
    @wizards = Wizard.order(:name).page(params[:page]).per(10)
  end
end
