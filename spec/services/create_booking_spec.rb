require "rails_helper"
include StripeHelpers

describe CreateBooking do
  let(:event) { FactoryGirl.create(:event, seats: 1) }
  let(:user) { FactoryGirl.create(:user) }

  context "user is not signed in" do
    let(:user) { nil }
    it { expect(described_class.perform(event, user)).to eq "You need to sign in or sign up before continuing." }
    it { expect { described_class.perform(event, user) }.to_not change { Booking.count } }
  end

  context "user has not yet completed their profile" do
    let!(:user) { FactoryGirl.create(:user_without_profile) }
    it { expect(described_class.perform(event, user)).to eq "Please complete your profile." }
    it { expect { described_class.perform(event, user) }.to_not change { Booking.count } }
  end

  context "event is sold out" do
    let!(:event) { FactoryGirl.create(:event, :sold_out) }
    it { expect(described_class.perform(event, user)).to eq "Sorry, this event has sold out." }
    it { expect { described_class.perform(event, user) }.to_not change { Booking.count } }
  end

  context "user is already booked on event" do
    before { Booking.create(event: event, user: user) }
    it { expect(described_class.perform(event, user)).to eq "You are already booked on this event." }
    it { expect { described_class.perform(event, user) }.to_not change { Booking.count } }
  end

  context "user is the host of the event" do
    let(:event) { FactoryGirl.create(:event, host: FactoryGirl.create(:host, user: user)) }
    it { expect(described_class.perform(event, user)).to eq "You cannot book yourself on your own event." }
    it { expect { described_class.perform(event, user) }.to_not change { Booking.count } }
  end

  context "payment token was not given" do
    it { expect(described_class.perform(event, user)).to eq "Please enable JavaScript for our payment system to work." }
    it { expect { described_class.perform(event, user) }.to_not change { Booking.count } }
  end

  context "payment was invalid" do
    around do |example|
      VCR.use_cassette("stripe/card_declined") do
        example.run
      end
    end

    it { expect(described_class.perform(event, user, StripeHelpers.card_declined_token)).to eq "The card number is not a valid credit card number." }
    it { expect { described_class.perform(event, user, StripeHelpers.card_declined_token) }.to_not change { Booking.count } }
  end

  context "booking successfully created" do
    let!(:event) { FactoryGirl.create(:event, seats: 2) }

    it "returns the correct message" do
      VCR.use_cassette("stripe/valid_card") do
        expect(described_class.perform(event, user, StripeHelpers.valid_card_token)).to eq "Thanks! We've booked you a seat."
      end
    end

    it "creates the Booking" do
      expect(Booking.count).to eq 0
      VCR.use_cassette("stripe/valid_card") do
        described_class.perform(event, FactoryGirl.create(:user), StripeHelpers.valid_card_token)
      end
      expect(Booking.count).to eq 1
      VCR.use_cassette("stripe/valid_card") do
        described_class.perform(event, FactoryGirl.create(:user), StripeHelpers.valid_card_token)
      end
      expect(Booking.count).to eq 2
      VCR.use_cassette("stripe/valid_card") do
        described_class.perform(event, FactoryGirl.create(:user), StripeHelpers.valid_card_token)
      end
      expect(Booking.count).to eq 2
    end
  end
end
