class WizardsController < ApplicationController
  def show
    @wizard = Wizard.find(params[:id])
  end
end
