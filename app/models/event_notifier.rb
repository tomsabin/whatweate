class EventNotifier
  def initialize(event)
    @event = event
  end

  def new_booking
    @event.fully_booked! if @event.bookings.size >= @event.seats
  end

  def new_event
    AdminMessenger.broadcast("New event by #{@event.host} has been submitted for approval")
  end
end
