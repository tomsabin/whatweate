class Event < ActiveRecord::Base
  extend FriendlyId
  include AASM

  belongs_to :host
  has_many :bookings, dependent: :destroy
  has_many :guests, through: :bookings, source: :user

  validates :host_id, :date, :date_date, :date_time, :title, :location, :location_url, :description, :menu, :seats, :price_in_pennies, :currency, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :seats, numericality: { only_integer: true, greater_than: 0 }
  validates :location_url, url: true
  validates :photos, length: { minimum: 2, maximum: 6, allow_blank: true }
  validates :short_description, length: { maximum: 80 }, presence: true

  monetize :price_in_pennies, as: "price", with_model_currency: :currency

  scope :most_recent, -> { order(created_at: :desc) }
  scope :approved, -> { where.not(state: :pending) }
  scope :upcoming, -> { where("DATE >= ?", DateTime.current.beginning_of_day) }
  scope :past, -> { where("DATE < ?", DateTime.current.beginning_of_day) }
  scope :booked_for, -> (user) { includes(:bookings).where("bookings.user_id = ?", user).references(:bookings) }

  friendly_id :title, use: :slugged

  mount_uploader :primary_photo, PrimaryPhotoUploader
  mount_uploaders :photos, PhotosUploader

  date_time_attribute :date

  aasm column: "state", whiny_transitions: false do
    state :pending, initial: true
    state :available
    state :sold_out

    event :approve do
      transitions from: :pending, to: :available
    end

    event :fully_booked do
      transitions from: :available, to: :sold_out
    end
  end

  def booked?(user)
    bookings.where(user: user).exists?
  end
end
