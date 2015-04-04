require 'rails_helper'

describe Profile do
  describe 'validations' do
    it { should belong_to(:user) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:date_of_birth) }
    it { should validate_presence_of(:profession) }
    it { should validate_presence_of(:bio) }
    it { should validate_presence_of(:mobile_number) }
    it { should validate_presence_of(:favorite_cuisine) }
    it { should_not validate_presence_of(:greeting) }
  end

  describe 'user association' do
    let!(:profile) { FactoryGirl.create(:profile) }

    it 'updates the associated user as well' do
      attributes = { bio: 'My new bio', user_attributes: { email: 'user@example.com', id: profile.user.id } }
      profile.update(attributes)
      profile.reload
      expect(profile.errors).to be_empty
      expect(profile.bio).to eq('My new bio')
      expect(profile.email).to eq('user@example.com')
    end
  end
end
