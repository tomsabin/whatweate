class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def self.provides_callback_for(provider)
    class_eval %Q{
      def flash_message
        if callback_originated_from_profile?
          :link_success
        elsif is_navigational_format?
          :auth_success
        end
      end

      def #{provider}
        @user = User.find_for_oauth(env["omniauth.auth"], current_user)

        if @user.persisted?
          sign_in_and_redirect(@user, event: :authentication)
          set_flash_message(:notice, flash_message, kind: "#{provider}".capitalize) if flash_message
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          redirect_to(new_user_registration_url)
        end
      end
    }
  end

  [:facebook, :twitter].each do |provider|
    provides_callback_for provider
  end

  def after_omniauth_failure_path_for(_scope)
    new_user_registration_url
  end

  def after_sign_in_path_for(resource)
    callback_originated_from_profile? ? profile_path : super
  end

  private

  def callback_originated_from_profile?
    env["omniauth.origin"] == profile_url
  end
end
