class Booking < ActiveRecord::Base
  include Wisper::Publisher

  belongs_to :event
  belongs_to :user

  validates :event_id, :user_id, presence: true

  after_create :publish_creation_successful

  def publish_creation_successful
    broadcast(:new_booking, self.event)
  end
end
