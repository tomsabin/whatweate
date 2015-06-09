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
    send_and_create_payment
  rescue Stripe::CardError => e
    errors.add(:base, e.message)
    false
  rescue => e
    Rails.logger.error("BookingPayment failed for #{user.email} for event [#{event.id}]")
    Rails.logger.error(e.inspect)
    errors.add(:base, I18n.t("failure.generic"))
    false
  end

  private
  attr_reader :token, :event, :user

  def send_and_create_payment
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

    Payment.create!(booking: booking, customer_reference: customer.id, charge_reference: charge.id)
  end
end
