class EventNotifier
  def create_booking_successful(booking)
    event = booking.event
    event.fully_booked! if event.bookings.size >= event.seats
  end

  def create_event_successful(event)
    link = Rails.application.routes.url_helpers.admin_event_url(event, host: Settings.app_host)
    AdminMessengerJob.perform_later("New event by #{event.host.name} has been submitted for approval: #{link}")
  end
end
