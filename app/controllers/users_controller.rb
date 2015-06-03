class UsersController < ApplicationController
  before_action :authenticate_user!

  def delete
  end

  def edit_password
    @user = current_user
  end

  def update_password
    @user = User.find(current_user.id)
    valid_password = @user.valid_password?(current_password)
    if valid_password && @user.update(user_params)
      sign_in(@user, bypass: true)
      redirect_to(profile_url, notice: "Your password was successfully updated")
    else
      @user.errors.add(:current_password, "was incorrect") unless valid_password
      render(:edit_password)
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def current_password
    params["user"]["current_password"]
  end
end
