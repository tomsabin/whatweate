class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :complete_profile, only: [:show, :edit]

  def show
    @profile = find_profile.decorate
    @verified_with_facebook = Identity.facebook(current_user)
    @verified_with_twitter = Identity.twitter(current_user)
  end

  def new
    @profile = find_profile
    redirect_to(profile_url) && return if @profile.present?
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(user: current_user)

    Profile.transaction do
      begin
        @profile.user.update!(user_params)
        @profile.update!(profile_params)
        redirect_to(profile_url, notice: "Thanks! Your profile has successfully been saved")
      rescue ActiveRecord::RecordInvalid
        flash.alert = "Please fill in the required fields"
        render(:new)
      end
    end
  end

  def edit
    @profile = find_profile
    @verified_with_facebook = Identity.facebook(current_user)
    @verified_with_twitter = Identity.twitter(current_user)
  end

  def update
    @profile = find_profile
    if @profile.update(profile_params.merge(user_attributes: user_params.merge(id: current_user.id)))
      redirect_to(profile_url, notice: "Your profile has successfully been saved")
    else
      render(:edit)
    end
  end

  private

  def complete_profile
    redirect_to(new_profile_url, profile_prompt: "Please complete your profile") if find_profile.blank?
  end

  def find_profile
    current_user.profile
  end

  def user_params
    params.require(:profile).require(:user).permit(:email, :first_name, :last_name)
  end

  def profile_params
    params.require(:profile).permit(profile_attributes)
  end

  def profile_attributes
    %i(date_of_birth profession greeting bio mobile_number favorite_cuisine date_of_birth_visible mobile_number_visible)
  end
end
