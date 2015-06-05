require "rails_helper"

describe UsersController do
  describe "GET show" do
    it "redirects to the new profile page if a user has not got a profile" do
      sign_in(FactoryGirl.create(:user_without_profile))
      get(:show)
      expect(response.status).to redirect_to(edit_user_path)
    end

    it "renders the page successfully for users with a profile" do
      sign_in(FactoryGirl.create(:user_with_profile))
      get(:show)
      expect(response.status).to eq(200)
    end
  end

  describe "GET edit" do
    it "renders the page successfully for users with a profile" do
      sign_in(FactoryGirl.create(:user_with_profile))
      get(:edit)
      expect(response.status).to eq(200)
    end
  end
end
