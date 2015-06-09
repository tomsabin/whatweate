class CreateBooking
  def self.perform(event, user, payment_token = nil)
    booking = Booking.new(event: event, user: user)
    booking.subscribe(EventNotifier.new)
    payment = Payment.new(booking, payment_token)

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
    elsif payment_token.blank?
      I18n.t("event.booking.javascript_disabled")
    elsif payment.save
      I18n.t("event.booking.success")
    elsif payment.errors.any?
      payment.errors.full_message
    else
      I18n.t("event.failure.generic")
    end
  end
end
