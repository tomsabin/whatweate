class RegistrationsController < Devise::RegistrationsController
  def create
    super
    resource.complete_devise! if resource.profile_incomplete? && resource.persisted?
  end
end
