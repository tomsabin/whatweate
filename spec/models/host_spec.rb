require "rails_helper"

describe Host do
  it { should belong_to(:user).inverse_of(:host) }
  it { should have_many(:events).dependent(:restrict_with_error) }

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "scopes" do
    let(:host_a) { FactoryGirl.create(:host, name: "Albert") }
    let(:host_z) { FactoryGirl.create(:host, name: "Zack") }

    it "orders by name alphabetically ascending" do
      expect(described_class.alphabetical).to eq [host_a, host_z]
    end
  end
end
