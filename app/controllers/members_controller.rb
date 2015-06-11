class MembersController < ApplicationController
  def show
    @user = User.friendly.find(params[:id]).decorate
    return redirect_to(action: :not_found, controller: :errors) unless @user.completed_profile?

    @verified_with_facebook = Identity.facebook?(@user)
    @verified_with_twitter = Identity.twitter?(@user)

    @upcoming_booked_events = @user.booked_events.upcoming
    @past_booked_events = @user.booked_events.past

    user_host = Host.find_by(user: @user)
    @user_is_host = user_host.present?
    @upcoming_hosted_events = user_host.events.upcoming if @user_is_host
    @past_hosted_events = user_host.events.past if @user_is_host
  end
end
