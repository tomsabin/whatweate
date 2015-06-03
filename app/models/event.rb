class Event < ActiveRecord::Base
  belongs_to :host
  has_many :bookings, dependent: :destroy

  validates :host_id, :date, :title, :location, :description, :menu, :seats, :price_in_pennies, :currency, presence: true

  monetize :price_in_pennies, as: 'price', with_model_currency: :currency

  scope :most_recent, -> { order(created_at: :desc) }

  def seated?(user)
    bookings.where(user: user).exists?
  end
end
