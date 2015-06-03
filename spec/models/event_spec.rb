require "rails_helper"

describe Event do
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
end
