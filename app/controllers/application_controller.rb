class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :store_location

  add_flash_types :profile_prompt

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :first_name, :last_name, :password) }
  end

  def store_location
    return unless request.get?
    return if request.path.include?("/admin") || request.path.include?("/users/")
    session[:user_return_to] = request.fullpath unless request.xhr?
  end

  def after_sign_in_path_for(resource)
    if user_signed_in? && resource.is_a?(User) && !resource.profile_complete?
      flash.discard
      flash[:profile_prompt] = t("profile.prompt")
      edit_user_url
    else
      super
    end
  end
end
