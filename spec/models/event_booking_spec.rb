require "rails_helper"

describe EventBooking do
  let(:event) { FactoryGirl.create(:event, seats: 2) }

  describe ".make" do
    it "creates the Booking" do
      expect(Booking.count).to eq 0
      described_class.make(event: event, user: FactoryGirl.create(:user))
      expect(Booking.count).to eq 1
      described_class.make(event: event, user: FactoryGirl.create(:user))
      expect(Booking.count).to eq 2
      described_class.make(event: event, user: FactoryGirl.create(:user))
      expect(Booking.count).to eq 2
    end

    it "returns true when the booking is created" do
      expect(described_class.make(event: event, user: FactoryGirl.create(:user))).to eq true
    end

    it "returns false when the booking cannot be created" do
      described_class.make(event: event, user: FactoryGirl.create(:user))
      described_class.make(event: event, user: FactoryGirl.create(:user))
      expect(described_class.make(event: event, user: FactoryGirl.create(:user))).to eq false
    end
  end
end
