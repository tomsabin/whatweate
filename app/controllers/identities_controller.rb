class IdentitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :assign_identity

  def destroy
    if @identity.present?
      @identity.destroy
      redirect_to(edit_profile_url, notice: "Successfully disconnected #{provider.capitalize} from your account")
    else
      redirect_to(edit_profile_url)
    end
  end

  private

  def assign_identity
    @identity = Identity.public_send(provider, current_user)
  end

  def provider
    params["provider"]
  end
end
