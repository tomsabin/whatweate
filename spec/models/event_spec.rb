require "rails_helper"

describe Event do
  it { should have_many(:bookings).dependent(:destroy) }
  it { should have_many(:guests).through(:bookings) }

  describe "validations" do
    it { should validate_presence_of(:host_id) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:menu) }
    it { should validate_presence_of(:seats) }
    it { should validate_presence_of(:price_in_pennies) }
    it { should validate_presence_of(:currency) }
  end

  describe "scopes" do
    describe "most_recent" do
      let(:event_1) { FactoryGirl.create(:event, title: "Event 1", created_at: 2.weeks.ago) }
      let(:event_2) { FactoryGirl.create(:event, title: "Event 2", created_at: 1.week.ago) }

      it "orders by the most recent first" do
        expect(described_class.most_recent).to eq [event_2, event_1]
      end
    end
  end

  describe "#seated?" do
    let(:event) { FactoryGirl.create(:event) }
    let(:user) { FactoryGirl.create(:user) }

    it "returns true if the user has already made a booking" do
      Booking.create(event: event, user: user)
      expect(event.seated?(user)).to eq true
    end

    it "returns false when the user hasn't made a booking" do
      expect(event.seated?(user)).to eq false
    end
  end

  describe "states" do
    describe "available" do
      let(:event) { FactoryGirl.create(:event) }

      it "is available" do
        expect(event.available?).to eq true
      end

      it "is not sold out" do
        expect(event.sold_out?).to eq false
      end
    end

    describe "sold_out" do
      let(:event) { FactoryGirl.create(:event, :sold_out) }

      it "is available" do
        expect(event.available?).to eq false
      end

      it "is not sold out" do
        expect(event.sold_out?).to eq true
      end
    end
  end

  describe "events" do
    describe "fully_booked" do
      let(:event) { FactoryGirl.create(:event) }

      it "available -> sold_out" do
        expect(event.available?).to eq(true)
        expect(event.sold_out?).to eq(false)
        event.fully_booked
        expect(event.available?).to eq(false)
        expect(event.sold_out?).to eq(true)
      end
    end
  end
end
