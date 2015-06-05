class OmniauthUser
  def self.find_or_create(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user
    user = new(auth).setup if user.nil?
    identity.update!(user: user) if identity.user != user
    user
  end

  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def setup
    user = User.new(
      email: email,
      first_name: auth["info"]["first_name"],
      last_name: auth["info"]["last_name"],
      password: Devise.friendly_token[0, 20],
      state: "omniauth_complete"
    )
    user.save!(validate: false)
    user
  end

  private

  def email
    auth_email.blank? || email_exists? ? nil : auth_email
  end

  def auth_email
    auth["info"]["email"]
  end

  def email_exists?
    auth_email.present? && User.find_by(email: auth_email).present?
  end
end
