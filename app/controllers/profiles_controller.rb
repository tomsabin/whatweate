class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id]).decorate
    redirect_to(action: :not_found, controller: :errors) && return unless @user.completed_profile?
    @verified_with_facebook = Identity.facebook(@user)
    @verified_with_twitter = Identity.twitter(@user)
  end
end
