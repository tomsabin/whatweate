class Event < ActiveRecord::Base
  include AASM

  belongs_to :host
  has_many :bookings, dependent: :destroy
  has_many :guests, through: :bookings, source: :user

  validates :host_id, :date, :title, :location, :location_url, :description, :menu, :seats, :price_in_pennies, :currency, presence: true
  validates :seats, numericality: { only_integer: true, greater_than: 0 }
  validates :location_url, url: true

  monetize :price_in_pennies, as: "price", with_model_currency: :currency

  scope :most_recent, -> { order(created_at: :desc) }
  scope :approved, -> { where.not(state: :pending) }
  scope :current, -> { where("DATE >= ?", Date.today) }
  scope :past, -> { where("DATE < ?", Date.today) }

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
