class CreateBooking
  def self.perform(event, user)
    booking = Booking.new(event: event, user: user)
    booking.subscribe(EventNotifier.new(event))

    if user.nil?
      I18n.t("devise.failure.unauthenticated")
    elsif !user.completed_profile?
      I18n.t("profile.prompt")
    elsif event.sold_out?
      I18n.t("event.booking.sold_out")
    elsif event.booked?(user)
      I18n.t("event.booking.duplicate")
    elsif booking.save
      I18n.t("event.booking.success")
    else
      I18n.t("failure.generic")
    end
  end
end
