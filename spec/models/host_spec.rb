require "rails_helper"

describe Host do
  describe "validations" do
    it { should belong_to(:profile) }
    it { should validate_presence_of(:name) }
  end
end
