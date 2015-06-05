class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %{
      def flash_message
        if callback_originated_from_user?
          :link_success
        elsif is_navigational_format?
          :auth_success
        end
      end

      def #{provider}
        begin
          @user = User.find_for_oauth!(env["omniauth.auth"], current_user)
        rescue OmniauthConflict
          redirect_to(user_url, notice: t("failure.omniauth_conflict", provider: "#{provider}".capitalize)) && return
        end

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
    callback_originated_from_user? ? user_url : super
  end

  private

  def callback_originated_from_user?
    env["omniauth.origin"] == user_url
  end
end
