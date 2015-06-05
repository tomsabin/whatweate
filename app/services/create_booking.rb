class CreateBooking
  def self.perform(event, user)
    if user.nil?
      I18n.t("devise.failure.unauthenticated")
    elsif event.sold_out?
      "Sorry, this event has sold out"
    elsif event.seated?(user)
      "You are already booked on this event"
    elsif EventBooking.make(event: event, user: user)
      "Thanks! We've booked you a seat"
    else
      I18n.t("failure.generic")
    end
  end
end
