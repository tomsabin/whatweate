class BookingPayment
  include ActiveModel::Validations
  attr_reader :booking

  def initialize(booking, token)
    @booking = booking
    @token   = token
    @event   = booking.event
    @user    = booking.user
  end

  def save
    @customer = Stripe::Customer.create(email: user.email, card: token)
    Payment.create!(booking: booking, customer_reference: customer.id, charge_reference: charge.id)
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
  attr_reader :token, :event, :user, :customer

  def charge
    Stripe::Charge.create(
      customer:    customer.id,
      amount:      event.price_in_pennies,
      description: event.title,
      currency:    event.currency
    )
  end
end
