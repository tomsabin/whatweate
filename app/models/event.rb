class Event < ActiveRecord::Base
  validates :title, :location, :description, :menu, :seats, :price_in_pennies, :currency, presence: true

  monetize :price_in_pennies, as: 'price', with_model_currency: :currency
end
