class MembersController < ApplicationController
  def show
    @user = User.friendly.find(params[:id]).decorate
    return redirect_to(action: :not_found, controller: :errors) unless @user.completed_profile?
    @verified_with_facebook = Identity.facebook(@user)
    @verified_with_twitter = Identity.twitter(@user)
    @current_booked_events = @user.booked_events.current
    @past_booked_events = @user.booked_events.past
  end
end
