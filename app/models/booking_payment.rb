class BookingPayment
  include ActiveModel::Validations
  attr_reader :booking

  def initialize(booking, token)
    @booking = booking
    @token = token
    @event = booking.event
    @user = booking.user
  end

  def save
    customer = Stripe::Customer.create(
      email: user.email,
      card:  token
    )

    charge = Stripe::Charge.create(
      customer:    customer.id,
      amount:      event.price_in_pennies,
      description: event.title,
      currency:    event.currency
    )

    Payment.create(booking: booking, customer_reference: customer.id, charge_reference: charge.id)
  rescue Stripe::CardError => e
    errors.add(:base, e.message)
  rescue => e
    errors.add(:base, I18n.t("failure.generic"))
  end

  private
  attr_reader :token, :event, :user
end
