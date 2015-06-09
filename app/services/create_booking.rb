class CreateBooking
  def self.perform(event, user)
    booking = Booking.new(event: event, user: user)
    booking.subscribe(EventNotifier.new)

    if user.nil?
      I18n.t("devise.failure.unauthenticated")
    elsif !user.completed_profile?
      I18n.t("profile.prompt")
    elsif event.sold_out?
      I18n.t("event.booking.sold_out")
    elsif event.booked?(user)
      I18n.t("event.booking.duplicate")
    elsif event.host == user.host
      I18n.t("event.booking.event_host")
    else
      I18n.t("event.booking.javascript_disabled")
    end
  end
end
