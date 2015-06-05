class IdentitiesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @identity = find_identity
    if @identity.present?
      @identity.destroy
      redirect_to(edit_profile_url, notice: "Successfully disconnected #{provider.capitalize} from your account")
    else
      redirect_to(edit_profile_url)
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
