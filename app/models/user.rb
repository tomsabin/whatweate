class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_one :profile, dependent: :destroy
  validates :first_name, :last_name, presence: true

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user

    if user.nil?
      user = User.new(
        first_name: auth["info"]["first_name"],
        last_name: auth["info"]["last_name"],
        password: Devise.friendly_token[0,20]
      )
      user.save(validate: false)
    end

    if identity.user != user
      identity.user = user
      identity.save!
    end

    user
  end
end
