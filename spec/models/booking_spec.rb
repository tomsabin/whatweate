require "rails_helper"

describe Booking do
  it { should belong_to(:event) }
  it { should belong_to(:user) }
  it { should have_one(:payment) }

  describe "validations" do
    it { should validate_presence_of(:event_id) }
    it { should validate_presence_of(:user_id) }
    it { should_not validate_presence_of(:payment) }
  end
end
