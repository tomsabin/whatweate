class Admin::AdminController < ApplicationController
  before_action :authenticate_admin!

  def dashboard
    render text: "Admin dashboard"
  end
end
