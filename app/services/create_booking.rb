class CreateBooking
  class << self
    def perform(event, user, payment_token = nil)
      booking = Booking.new(event: event, user: user)
      booking.subscribe(EventNotifier.new)

      user_response(user) || event_response(event, user) || payment_response(booking, payment_token) || failure_response
    end

    private

    def user_response(user)
      if user.nil?
        I18n.t("devise.failure.unauthenticated")
      elsif !user.completed_profile?
        I18n.t("profile.prompt")
      end
    end

    def event_response(event, user)
      if event.sold_out?
        I18n.t("event.booking.sold_out")
      elsif event.booked?(user)
        I18n.t("event.booking.duplicate")
      elsif event.host == user.host
        I18n.t("event.booking.event_host")
      end
    end

    def payment_response(booking, payment_token)
      payment = BookingPayment.new(booking, payment_token)
      if payment_token.blank?
        I18n.t("event.booking.javascript_disabled")
      elsif payment.save
        I18n.t("event.booking.success")
      elsif payment.errors.any?
        payment.errors.full_messages.first
      end
    end

    def failure_response
      I18n.t("event.failure.generic")
    end
  end
end
