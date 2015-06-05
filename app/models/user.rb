class User < ActiveRecord::Base
  REQUIRED_USER_ATTRIBUTES = %i(first_name last_name)
  REQUIRED_PROFILE_ATTRIBUTES = REQUIRED_USER_ATTRIBUTES + %i(date_of_birth profession bio mobile_number favorite_cuisine)

  has_many :bookings, dependent: :destroy

  validates *REQUIRED_USER_ATTRIBUTES, presence: true, if: "created_at.blank?"
  validates *REQUIRED_PROFILE_ATTRIBUTES, presence: true, if: "created_at.present?"

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def self.find_for_oauth(auth, signed_in_resource = nil)
    OmniauthUser.find_or_create(auth, signed_in_resource)
  end
end
