require "rails_helper"

describe CreateBooking do
  let(:event) { FactoryGirl.create(:event, seats: 1) }
  let(:user) { FactoryGirl.create(:user) }

  describe "messaging" do
    context "user is not signed in" do
      let(:user) { nil }
      it { expect(described_class.perform(event, user)).to eq "You need to sign in or sign up before continuing." }
    end

    context "user has not yet completed their profile" do
      let(:user) { FactoryGirl.create(:user_without_profile) }
      it { expect(described_class.perform(event, user)).to eq "Please complete your profile." }
    end

    context "event is sold out" do
      let(:event) { FactoryGirl.create(:event, :sold_out) }
      it { expect(described_class.perform(event, user)).to eq "Sorry, this event has sold out." }
    end

    context "user is already booked on event" do
      before { Booking.create(event: event, user: user) }
      it { expect(described_class.perform(event, user)).to eq "You are already booked on this event." }
    end
  end
end
