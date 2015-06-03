class EventNotifier
  def initialize(event)
    @event = event
  end

  def new_booking
    @event.fully_booked! if @event.bookings.size >= @event.seats
  end
end
