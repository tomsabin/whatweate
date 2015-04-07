class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  add_flash_types :profile_prompt

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :first_name, :last_name, :password) }
  end

  def after_sign_in_path_for(resource)
    if resource.profile.present?
      super
    else
      flash.discard
      flash[:profile_prompt] = "Please complete your profile"
      new_profile_path
    end
  end
end
