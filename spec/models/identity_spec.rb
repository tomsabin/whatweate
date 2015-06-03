require "rails_helper"

describe Identity do
  it { should belong_to(:user) }

  describe "validations" do
    it { should validate_presence_of(:uid) }
    it { should validate_presence_of(:provider) }
    it { should validate_uniqueness_of(:uid).scoped_to(:provider) }
  end
end
