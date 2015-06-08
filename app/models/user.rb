class User < ActiveRecord::Base
  extend FriendlyId
  include AASM

  has_many :bookings, dependent: :destroy
  has_many :booked_events, through: :bookings, source: :event
  has_one :host, inverse_of: :user

  with_options if: -> { profile_incomplete? } do |u|
    u.validates :first_name, :last_name, presence: true
  end

  with_options if: -> { completed_devise? || completed_omniauth? || completed_profile? } do |u|
    u.validates :first_name, :last_name, :date_of_birth, :profession, :bio, :mobile_number, :favorite_cuisine, presence: true
  end

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  friendly_id :full_name, use: :slugged

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

  def full_name
    "#{first_name} #{last_name}"
  end
end
