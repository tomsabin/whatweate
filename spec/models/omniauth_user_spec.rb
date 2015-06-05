require "rails_helper"
include OmniauthHelpers

describe OmniauthUser do
  describe ".find_or_create!" do
    it "finds the user by an existing identity (facebook) when the user is not signed in" do
      user = FactoryGirl.create(:user, :facebook)
      expect(OmniauthUser.find_or_create!(facebook_auth_hash)).to eq(user)
    end

    it "creates the user with the identity (twitter) association when the user is not signed in" do
      expect(User.count).to eq(0)
      expect(Identity.count).to eq(0)

      user = OmniauthUser.find_or_create!(twitter_auth_hash)
      identity = Identity.last

      expect(User.count).to eq(1)
      expect(Identity.count).to eq(1)
      expect(user).to_not be_valid
      expect(user).to be_persisted
      expect(user.state).to eq("omniauth_complete")
      expect(user.email).to eq(nil)
      expect(user.first_name).to eq(nil)
      expect(user.last_name).to eq(nil)
      expect(identity.user).to eq(user)
      expect(identity.provider).to eq("twitter")
    end

    it "creates the user with the identity (facebook) association when the user is not signed in" do
      expect(User.count).to eq(0)
      expect(Identity.count).to eq(0)

      user = OmniauthUser.find_or_create!(facebook_auth_hash)
      identity = Identity.last

      expect(User.count).to eq(1)
      expect(Identity.count).to eq(1)
      expect(user).to_not be_valid
      expect(user).to be_persisted
      expect(user.state).to eq("omniauth_complete")
      expect(user.email).to eq("user@example.com")
      expect(user.first_name).to eq("Cookie")
      expect(user.last_name).to eq("Monster")
      expect(identity.user).to eq(user)
      expect(identity.provider).to eq("facebook")
    end

    it "associates the new identity to the user when the user is signed in" do
      current_user = FactoryGirl.create(:user_without_profile)
      expect(Identity.count).to eq(0)

      OmniauthUser.find_or_create!(facebook_auth_hash, current_user)
      identity = Identity.last

      expect(Identity.count).to eq(1)

      expect(current_user.first_name).to_not eq("Cookie")
      expect(current_user.last_name).to_not eq("Monster")
      expect(identity.user).to eq(current_user)
      expect(identity.provider).to eq("facebook")
    end

    it "does not use the email if it already exists" do
      FactoryGirl.create(:user, email: "user@example.com")
      OmniauthUser.find_or_create!(facebook_auth_hash)
      expect(User.last.email).to eq(nil)
    end

    it "creates an invalid User with email if another User exists" do
      user_1 = OmniauthUser.find_or_create!(twitter_auth_hash)
      expect(User.count).to eq(1)
      expect(user_1.email).to eq(nil)

      user_2 = OmniauthUser.find_or_create!(twitter_auth_hash.merge("uid" => "abcdef"))
      expect(User.count).to eq(2)
      expect(user_2.email).to eq(nil)
    end

    it "raises an error when verifying an identity with another user" do
      user_1 = OmniauthUser.find_or_create!(facebook_auth_hash)
      facebook_identity = Identity.first
      user_2 = OmniauthUser.find_or_create!(twitter_auth_hash)
      expect { OmniauthUser.find_or_create!(facebook_auth_hash, user_2) }.to raise_error { OmniauthConflict.new }
      expect(facebook_identity.reload.user).to eq user_1
    end

    it "does not raise an error when verifying an identity with the same user" do
      user_1 = OmniauthUser.find_or_create!(facebook_auth_hash)
      facebook_identity = Identity.first
      expect { OmniauthUser.find_or_create!(facebook_auth_hash, user_1) }.to_not raise_error { OmniauthConflict.new }
      expect(facebook_identity.reload.user).to eq user_1
    end
  end
end
