require "rails_helper"
include OmniauthHelpers

describe OmniauthUser do
  describe ".find_or_create" do
    it "finds the user by an existing identity (facebook) when the user is not signed in" do
      user = FactoryGirl.create(:user, :authorised_with_facebook)
      expect(OmniauthUser.find_or_create(facebook_auth_hash)).to eq(user)
    end

    it "creates the user with the identity (twitter) association when the user is not signed in" do
      expect(User.count).to eq(0)
      expect(Identity.count).to eq(0)

      user = OmniauthUser.find_or_create(twitter_auth_hash)
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

      user = OmniauthUser.find_or_create(facebook_auth_hash)
      identity = Identity.last

      expect(User.count).to eq(1)
      expect(Identity.count).to eq(1)
      expect(user).to be_valid
      expect(user.persisted?).to be_truthy
      expect(user.email).to eq("user@example.com")
      expect(user.first_name).to eq("Cookie")
      expect(user.last_name).to eq("Monster")
      expect(identity.user).to eq(user)
      expect(identity.provider).to eq("facebook")
    end

    it "associates the new identity to the user when the user is signed in" do
      current_user = FactoryGirl.create(:user_without_profile)
      expect(Identity.count).to eq(0)

      OmniauthUser.find_or_create(facebook_auth_hash, current_user)
      identity = Identity.last

      expect(Identity.count).to eq(1)

      expect(current_user.first_name).to_not eq("Cookie")
      expect(current_user.last_name).to_not eq("Monster")
      expect(identity.user).to eq(current_user)
      expect(identity.provider).to eq("facebook")
    end

    it "does not use the email if it already exists" do
      FactoryGirl.create(:user, email: "user@example.com")
      OmniauthUser.find_or_create(facebook_auth_hash)
      expect(User.last.email).to be_blank
    end
  end
end
