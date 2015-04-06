class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect(@user, event: :authentication)
      flash.notice = flash_message("Facebook")
    else
      session["devise.facebook_data"] = env["omniauth.auth"]
      redirect_to(new_user_registration_url)
    end
  end

  def twitter
    @user = User.find_for_oauth(env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect(@user, event: :authentication)
      flash.notice = flash_message("Twitter")
    else
      session["devise.twitter_data"] = env["omniauth.auth"]
      redirect_to(new_user_registration_url)
    end
  end

  def after_omniauth_failure_path_for(scope)
    new_user_registration_url
  end

  def after_sign_in_path_for(resource)
    callback_originated_from_profile? ? profile_path : super
  end

  private

  def flash_message(provider)
    if callback_originated_from_profile?
      "Successfully verified your account with #{provider}"
    elsif is_navigational_format?
      "Successfully authenticated from #{provider} account"
    end
  end

  def callback_originated_from_profile?
    env["omniauth.origin"] == profile_url
  end
end
