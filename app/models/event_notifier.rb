class EventNotifier
  def new_booking(event)
    event.fully_booked! if event.bookings.size >= event.seats
  end

  def new_event(event)
    AdminMessenger.broadcast("New event by #{event.host.name} has been submitted for approval")
  end
end
