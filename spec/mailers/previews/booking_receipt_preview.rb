class BookingReceiptPreview < ActionMailer::Preview
  def booking_receipt
    UserMailer.booking_receipt(User.first, Event.first)
  end
end
