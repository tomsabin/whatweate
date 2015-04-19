require "rails_helper"

describe Event do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:menu) }
    it { should validate_presence_of(:seats) }
    it { should validate_presence_of(:price_in_pennies) }
    it { should validate_presence_of(:currency) }
  end
end
