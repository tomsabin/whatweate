class CreateBooking
  def self.perform(event, user)
    if user.nil?
      I18n.t("devise.failure.unauthenticated")
    elsif !user.completed_profile?
      I18n.t("profile.prompt")
    elsif event.sold_out?
      I18n.t("event.booking.sold_out")
    elsif event.booked?(user)
      I18n.t("event.booking.duplicate")
    elsif EventBooking.make(event: event, user: user)
      I18n.t("event.booking.success")
    else
      I18n.t("failure.generic")
    end
  end
end
