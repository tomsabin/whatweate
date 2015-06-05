class User < ActiveRecord::Base
  include AASM

  has_many :bookings, dependent: :destroy

  with_options if: -> { profile_incomplete? || devise_complete? } do |u|
    u.validates :first_name, :last_name, presence: true
  end

  with_options if: -> { omniauth_complete? || profile_complete? } do |u|
    u.validates :first_name, :last_name, :date_of_birth, :profession, :bio, :mobile_number, :favorite_cuisine, presence: true
  end

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  aasm column: "state", whiny_transitions: false do
    state :profile_incomplete, initial: true
    state :devise_complete
    state :omniauth_complete
    state :profile_complete

    event :complete_devise do
      transitions to: :devise_complete, from: :profile_incomplete
    end

    event :complete_profile do
      transitions to: :profile_complete, from: :devise_complete
      transitions to: :profile_complete, from: :omniauth_complete
    end
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    OmniauthUser.find_or_create(auth, signed_in_resource)
  end
end
