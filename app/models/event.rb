class Event < ActiveRecord::Base
  validates :title, :location, :description, :menu, :seats, :price_in_pennies, :currency, presence: true
end
