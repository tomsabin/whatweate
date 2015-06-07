class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id]).decorate
    redirect_to(action: :not_found, controller: :errors) unless @user.completed_profile?
  end
end
