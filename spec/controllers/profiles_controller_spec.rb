require "rails_helper"

describe ProfilesController do
  describe "GET new" do
    it "redirects to the registration page for unauthenticated users" do
      sign_in(nil)
      get(:new)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects to the profile show page if a user has a profile" do
      sign_in(FactoryGirl.build(:user_with_profile))
      get(:new)
      expect(response).to redirect_to(profile_path)
    end

    it "renders the page successfully for authenticated users" do
      sign_in(FactoryGirl.build(:user_without_profile))
      get(:new)
      expect(response.status).to eq(200)
    end
  end

  describe "GET show" do
    it "redirects to the new profile page if a user has not got a profile" do
      sign_in(FactoryGirl.build(:user_without_profile))
      get(:show)
      expect(response.status).to redirect_to(new_profile_path)
    end

    it "renders the page successfully for users with a profile" do
      sign_in(FactoryGirl.build(:user_with_profile))
      get(:show)
      expect(response.status).to eq(200)
    end
  end

  describe "GET edit" do
    it "redirects to the new profile page if a user has not got a profile" do
      sign_in(FactoryGirl.build(:user_without_profile))
      get(:edit)
      expect(response.status).to redirect_to(new_profile_path)
    end

    it "renders the page successfully for users with a profile" do
      sign_in(FactoryGirl.build(:user_with_profile))
      get(:edit)
      expect(response.status).to eq(200)
    end
  end
end
