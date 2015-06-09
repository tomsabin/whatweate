require "rails_helper"

describe BookingPayment do
  subject { described_class.new(booking, token) }
  let(:booking) { Booking.new(user: FactoryGirl.create(:user), event: FactoryGirl.create(:event)) }

  context "valid details" do
    let(:token) { "valid-token" }

    it "saves the Payment" do
      subject.save
      payment = Payment.last
      expect(payment).to be_present
      expect(payment.customer_reference).to eq "customer"
      expect(payment.charge_reference).to eq "charge"
      expect(payment.booking).to eq Booking.last
    end

    it "saves the Booking" do
      subject.save
      booking = Booking.last
      expect(booking).to be_present
      expect(booking.payment).to eq Payment.last
      expect(booking.event).to eq Event.last
      expect(booking.user).to eq User.last
    end

    it "does not have any errors" do
      subject.save
      expect(subject.errors).to be_blank
      expect(subject.errors.full_messages).to be_blank
    end
  end

  context "incorrect card number"
  context "invalid card number"
  context "invalid expiry month"
  context "invalid expiry year"
  context "invalid cvc"
  context "expired card"
  context "incorrect cvc"
  context "processing error"
  context "API rate limit"
end
