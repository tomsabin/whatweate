class UserNotifier
  def create_booking_successful(booking)
    UserMailer.booking_receipt(booking.user, booking.event).deliver_later
  end

  def create_host_successful(host)
    UserMailer.new_host(host.user).deliver_later
  end
end
