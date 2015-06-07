class User < ActiveRecord::Base
  include AASM

  has_many :bookings, dependent: :destroy

  with_options if: -> { profile_incomplete? } do |u|
    u.validates :first_name, :last_name, presence: true
  end

  with_options if: -> { completed_devise? || completed_omniauth? || completed_profile? } do |u|
    u.validates :first_name, :last_name, :date_of_birth, :profession, :bio, :mobile_number, :favorite_cuisine, presence: true
  end

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  aasm column: "state", whiny_transitions: false, skip_validation_on_save: true do
    state :profile_incomplete, initial: true
    state :completed_devise
    state :completed_omniauth
    state :completed_profile

    event :complete_devise do
      transitions to: :completed_devise, from: :profile_incomplete
    end

    event :complete_profile do
      transitions to: :completed_profile, from: [:completed_devise, :completed_omniauth]
    end
  end

  def self.find_for_oauth!(auth, signed_in_resource = nil)
    OmniauthUser.find_or_create!(auth, signed_in_resource)
  end
end
