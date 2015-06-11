class Booking < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_one :payment

  validates :event_id, :user_id, presence: true
end
