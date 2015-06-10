require "rails_helper"

describe Identity do
  it { should belong_to(:user) }

  describe "validations" do
    it { should validate_presence_of(:uid) }
    it { should validate_presence_of(:provider) }
    it { should validate_uniqueness_of(:uid).scoped_to(:provider) }
  end

  describe ".facebook?" do
    let(:user) { FactoryGirl.create(:user, :facebook) }
    it { expect(described_class.facebook?(user)).to eq true }
  end

  describe ".facebook" do
    let(:user) { FactoryGirl.create(:user, :facebook) }

    it "returns the identity" do
      expect(described_class.facebook(user)).to eq Identity.last
    end
  end

  describe ".twitter?" do
    let(:user) { FactoryGirl.create(:user, :twitter) }
    it { expect(described_class.twitter?(user)).to eq true }
  end

  describe ".twitter" do
    let(:user) { FactoryGirl.create(:user, :twitter) }

    it "returns the identity" do
      expect(described_class.twitter(user)).to eq Identity.last
    end
  end
end
