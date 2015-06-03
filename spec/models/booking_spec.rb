require "rails_helper"

describe Booking do
  describe "validations" do
    it { should belong_to(:event) }
    it { should belong_to(:user) }
    it { should validate_presence_of(:event_id) }
    it { should validate_presence_of(:user_id) }
  end
end
