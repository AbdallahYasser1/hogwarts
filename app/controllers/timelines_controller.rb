class TimelinesController < ApplicationController
  def show
    @user = Wizard.find(params[:wizard_id])
    @timeline = TimelineService.get_user_timeline(current_wizard.id, 10)
  end
end
