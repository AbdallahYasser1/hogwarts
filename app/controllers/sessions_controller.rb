class SessionsController < ApplicationController
  def new
    # Renders the login form
  end

  def create
      wizard = SessionService.new(params, cookies, session).login
      if wizard
        flash[:info] = "Logged in successfully"
        redirect_to landing_path
      else
        flash.now[:alert] = "Invalid email or password."
        render :new
      end
  end

  def destroy
    SessionService.new(params, cookies, session).logout(current_wizard)
    redirect_to login_path, notice: "Logged out successfully."
  end
end
