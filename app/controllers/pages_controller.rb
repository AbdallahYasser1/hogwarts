class PagesController < ApplicationController
  skip_before_action :authenticate_wizard!, only: [ :landing ]

  def landing
  end

  def home
  end
end
