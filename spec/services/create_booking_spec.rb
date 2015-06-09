require "rails_helper"

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
    it { expect(described_class.perform(event, user, "invalid-token")).to eq "The card number is not a valid credit card number." }
    it { expect { described_class.perform(event, user, "invalid-token") }.to_not change { Booking.count } }
  end

  context "booking successfully created" do
    let!(:event) { FactoryGirl.create(:event, seats: 2) }
    it { expect(described_class.perform(event, user, "valid-token")).to eq "Thanks! We've booked you a seat." }
    it "creates the Booking" do
      expect(Booking.count).to eq 0
      described_class.perform(event, FactoryGirl.create(:user), "valid-token")
      expect(Booking.count).to eq 1
      described_class.perform(event, FactoryGirl.create(:user), "valid-token")
      expect(Booking.count).to eq 2
      described_class.perform(event, FactoryGirl.create(:user), "valid-token")
      expect(Booking.count).to eq 2
    end
  end
end
