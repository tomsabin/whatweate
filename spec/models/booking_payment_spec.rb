require "rails_helper"
include StripeHelpers

describe BookingPayment do
  let(:event) { FactoryGirl.create(:event, price_in_pennies: 1000, title: "Event title") }
  let(:booking) { Booking.new(user: FactoryGirl.create(:user), event: event) }
  let(:subject) { described_class.new(booking, token) }

  describe "charging the user" do
    let(:token) { StripeHelpers.valid_card_token }

    it "is the correct amount" do
      expect(Stripe::Charge).to receive(:create).with(hash_including(amount: 1000, currency: "GBP", description: "Event title"))
      VCR.use_cassette("stripe/valid_card") { subject.save }
    end
  end

  context "tokens from Checkout" do
    context "token validated by Checkout and can be charged" do
      let(:token) { StripeHelpers.valid_card_token }
      let(:cassette) { "stripe/valid_card" }

      it "saves the Payment" do
        VCR.use_cassette(cassette) { subject.save }
        payment = Payment.last
        expect(payment).to be_present
        expect(payment.customer_reference).to eq "cus_6OZPJHyHVOyNNS"
        expect(payment.charge_reference).to eq "ch_16BmGZBb51nepfzbEhTpAalj"
        expect(payment.booking).to eq Booking.last
      end

      it "saves the Booking" do
        VCR.use_cassette(cassette) { subject.save }
        booking = Booking.last
        expect(booking).to be_present
        expect(booking.payment).to eq Payment.last
        expect(booking.event).to eq Event.last
        expect(booking.user).to eq User.last
      end

      it "does not have any errors" do
        VCR.use_cassette(cassette) { subject.save }
        expect(subject.errors.full_messages).to be_blank
      end

      it "returns a truthy value" do
        VCR.use_cassette(cassette) do
          expect(subject.save).to be_truthy
        end
      end
    end

    context "token validated by Checkout but cannot be charged" do
      let(:token) { StripeHelpers.card_error_token }
      let(:cassette) { "stripe/card_error" }

      it "does not save a Payment" do
        VCR.use_cassette(cassette) { subject.save }
        expect(Payment.count).to eq(0)
      end

      it "does not save a Booking" do
        VCR.use_cassette(cassette) { subject.save }
        expect(Booking.count).to eq(0)
      end

      it "has errors from Stripe" do
        VCR.use_cassette(cassette) { subject.save }
        expect(subject.errors.full_messages).to eq ["Your card was declined."]
      end

      it "returns a falsey value" do
        VCR.use_cassette(cassette) do
          expect(subject.save).to be_falsey
        end
      end
    end

    context "token validated by Checkout but card was declined" do
      let(:token) { StripeHelpers.card_declined_token }
      let(:cassette) { "stripe/card_declined" }

      it "does not save a Payment" do
        VCR.use_cassette(cassette) { subject.save }
        expect(Payment.count).to eq(0)
      end

      it "does not save a Booking" do
        VCR.use_cassette(cassette) { subject.save }
        expect(Booking.count).to eq(0)
      end

      it "has errors from Stripe" do
        VCR.use_cassette(cassette) { subject.save }
        expect(subject.errors.full_messages).to eq ["Your card was declined."]
      end

      it "returns a falsey value" do
        VCR.use_cassette(cassette) do
          expect(subject.save).to be_falsey
        end
      end
    end

    context "something else goes wrong" do
      let(:token) { StripeHelpers.valid_card_token }
      let(:cassette) { "stripe/valid_card" }

      before do
        allow(Stripe::Customer).to receive(:create).and_raise(Stripe::StripeError.new)
      end

      it "has generic errors" do
        VCR.use_cassette(cassette) { subject.save }
        expect(subject.errors.full_messages).to eq ["Oops, something went wrong."]
      end

      it "returns a falsey value" do
        VCR.use_cassette(cassette) do
          expect(subject.save).to be_falsey
        end
      end
    end
  end
end
