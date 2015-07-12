class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :complete_profile, only: :show

  def show
    @user = current_user.decorate
    @verified_with_facebook = Identity.facebook(current_user)
    @verified_with_twitter = Identity.twitter(current_user)
  end

  def edit
    @user = current_user.decorate
    @verified_with_facebook = Identity.facebook(current_user)
    @verified_with_twitter = Identity.twitter(current_user)
    if current_user.completed_profile?
      render :edit
    else
      render :complete_profile
    end
  end

  def update
    @user = current_user
    if @user.update(user_params)
      @user.complete_profile! if @user.completed_devise? || @user.completed_omniauth?
      redirect_to(user_url, notice: t("profile.saved"))
    elsif current_user.completed_profile?
      render :edit
    else
      render :complete_profile
    end
  end

  def edit_password
    @user = current_user
  end

  def update_password
    @user = User.find(current_user.id)
    valid_password = @user.valid_password?(current_password)
    if valid_password && @user.update(password_params)
      sign_in(@user, bypass: true)
      redirect_to(user_url, notice: t("devise.passwords.updated_not_active"))
    else
      @user.errors.add(:current_password, "was incorrect") unless valid_password
      render(:edit_password)
    end
  end

  def delete
  end

  private

  def complete_profile
    redirect_to(edit_user_url, profile_prompt: t("profile.prompt")) unless current_user.completed_profile?
  end

  def user_params
    params.require(:user).permit(user_attributes)
  end

  def user_attributes
    %i(email first_name last_name date_of_birth profession greeting bio mobile_number favorite_cuisine date_of_birth_visible mobile_number_visible slug)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def current_password
    params["user"]["current_password"]
  end
end
