class Event < ActiveRecord::Base
  belongs_to :host

  validates :host_id, :title, :location, :description, :menu, :seats, :price_in_pennies, :currency, presence: true

  monetize :price_in_pennies, as: 'price', with_model_currency: :currency

  scope :most_recent, -> { order(created_at: :desc) }
end
