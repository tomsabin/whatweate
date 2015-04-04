require "rails_helper"
include OmniAuthHelpers

describe User do
  describe "validations" do
    it { should have_one(:profile).dependent(:destroy) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
  end

  describe ".find_for_oauth" do
    it "finds the user by an existing identity (facebook) when the user is not signed in" do
      user = FactoryGirl.create(:user, :authorised_with_facebook)
      expect(User.find_for_oauth(facebook_auth_hash)).to eq(user)
    end

    it "creates the user with the identity (twitter) association when the user is not signed in" do
      expect(User.count).to eq(0)
      expect(Identity.count).to eq(0)

      user = User.find_for_oauth(twitter_auth_hash)
      identity = Identity.last

      expect(User.count).to eq(1)
      expect(Identity.count).to eq(1)
      expect(user).to_not be_valid
      expect(user.persisted?).to be_truthy
      expect(user.email).to be_blank
      expect(user.first_name).to be_blank
      expect(user.last_name).to be_blank
      expect(identity.user).to eq(user)
      expect(identity.provider).to eq("twitter")
    end

    it "creates the user with the identity (facebook) association when the user is not signed in" do
      expect(User.count).to eq(0)
      expect(Identity.count).to eq(0)

      user = User.find_for_oauth(facebook_auth_hash)
      identity = Identity.last

      expect(User.count).to eq(1)
      expect(Identity.count).to eq(1)
      expect(user).to_not be_valid
      expect(user.persisted?).to be_truthy
      expect(user.email).to be_blank
      expect(user.first_name).to eq("Cookie")
      expect(user.last_name).to eq("Monster")
      expect(identity.user).to eq(user)
      expect(identity.provider).to eq("facebook")
    end

    it "associates the new identity to the user when the user is signed in" do
      current_user = FactoryGirl.create(:user_without_profile)
      expect(Identity.count).to eq(0)

      User.find_for_oauth(facebook_auth_hash, current_user)
      identity = Identity.last

      expect(Identity.count).to eq(1)

      expect(current_user.first_name).to_not eq("Cookie")
      expect(current_user.last_name).to_not eq("Monster")
      expect(identity.user).to eq(current_user)
      expect(identity.provider).to eq("facebook")
    end
  end
end
