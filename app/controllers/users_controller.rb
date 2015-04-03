class UsersController < ApplicationController
  before_filter :authenticate_user!

  def edit_password
    @user = current_user
  end

  def update_password
    @user = User.find(current_user.id)
    valid_password = @user.valid_password?(current_password)
    if valid_password && @user.update(user_params)
      sign_in(@user, bypass: true)
      redirect_to(profile_path, notice: 'Your password was successfully updated')
    else
      @user.errors.add(:current_password, 'was incorrect') if !valid_password
      render(:edit_password)
    end
  end

  private

  def user_params
    params.required(:user).permit(:password, :password_confirmation)
  end

  def current_password
    params['user']['current_password']
  end
end
