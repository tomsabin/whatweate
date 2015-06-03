require "rails_helper"

describe "Devise" do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

  scenario "handles multiple scopes successfully" do
    sign_in user
    sign_in admin
    visit admin_root_path
    visit profile_path
  end
end
