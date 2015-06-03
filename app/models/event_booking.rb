module EventBooking
  def self.make(event:, user:)
    return false if event.sold_out?
    booking = Booking.new(event: event, user: user)
    booking.subscribe(EventNotifier.new(event))
    booking.save
  end
end
