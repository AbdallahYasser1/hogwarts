class PagesController < ApplicationController
  skip_before_action :authenticate_wizard!, only: [ :landing ]

  def landing
  end

  def home
    # This will be the magical home page for logged-in users
  end
end
