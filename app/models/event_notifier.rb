class EventNotifier
  def create_booking_successful(booking)
    event = booking.event
    event.fully_booked! if event.bookings.size >= event.seats
  end

  def create_event_successful(event)
    AdminMessenger.broadcast("New event by #{event.host.name} has been submitted for approval")
  end
end
