class IdentitiesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @identity = find_identity
    if @identity.present?
      @identity.destroy
      redirect_to(edit_user_url, notice: t("devise.omniauth_callbacks.disconnect", provider: provider.capitalize))
    else
      redirect_to(edit_user_url)
    end
  end

  private

  def find_identity
    Identity.public_send(provider, current_user)
  end

  def provider
    params["provider"]
  end
end
