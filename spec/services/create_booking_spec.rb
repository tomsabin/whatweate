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
      VCR.use_cassette("stripe/card_declined") { example.run }
    end

    it { expect(described_class.perform(event, user, StripeHelpers::CARD_DECLINED_TOKEN)).to eq "Your card was declined." }
    it { expect { described_class.perform(event, user, StripeHelpers::CARD_DECLINED_TOKEN) }.to_not change { Booking.count } }

    it "does not email a receipt to the User" do
      ActionMailer::Base.deliveries.clear
      user = FactoryGirl.create(:user)
      expect(ActionMailer::Base.deliveries.count).to eq(0)
      described_class.perform(event, user, StripeHelpers::CARD_DECLINED_TOKEN)
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end
  end

  context "booking successfully created" do
    let!(:event) { FactoryGirl.create(:event, seats: 2) }

    it "returns the correct message" do
      VCR.use_cassette("stripe/valid_card") do
        expect(described_class.perform(event, user, StripeHelpers::VALID_CARD_TOKEN)).to eq "Thanks! We've booked you a seat."
      end
    end

    it "creates the Booking" do
      expect(Booking.count).to eq 0
      VCR.use_cassette("stripe/valid_card") do
        described_class.perform(event, FactoryGirl.create(:user), StripeHelpers::VALID_CARD_TOKEN)
      end
      expect(Booking.count).to eq 1
      VCR.use_cassette("stripe/valid_card") do
        described_class.perform(event, FactoryGirl.create(:user), StripeHelpers::VALID_CARD_TOKEN)
      end
      expect(Booking.count).to eq 2
      VCR.use_cassette("stripe/valid_card") do
        described_class.perform(event, FactoryGirl.create(:user), StripeHelpers::VALID_CARD_TOKEN)
      end
      expect(Booking.count).to eq 2
    end

    it "emails a receipt to the User" do
      ActionMailer::Base.deliveries.clear
      user = FactoryGirl.create(:user)
      expect(ActionMailer::Base.deliveries.count).to eq(0)
      VCR.use_cassette("stripe/valid_card") do
        described_class.perform(event, user, StripeHelpers::VALID_CARD_TOKEN)
      end

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(ActionMailer::Base.deliveries.last.subject).to eq("Your receipt for #{event.title}")
    end
  end
end
