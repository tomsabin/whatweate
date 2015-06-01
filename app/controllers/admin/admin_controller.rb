class Admin::AdminController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'

  def dashboard
    render 'admin/dashboard'
  end
end
