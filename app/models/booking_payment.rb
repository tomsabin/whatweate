class BookingPayment
  include ActiveModel::Validations
  attr_reader :booking, :payment

  def initialize(booking, token)
    @booking = booking
    @token = token
  end

  def save
    @payment = Payment.create(booking: booking, customer_reference: "customer", charge_reference: "charge")
  end

  private
  attr_reader :token
end
