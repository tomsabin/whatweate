require "rails_helper"
include OmniauthHelpers

describe "Admins" do
  let(:admin) { FactoryGirl.create(:admin) }

  scenario "signs in to dashboard" do
    visit admin_root_path

    expect(page).to have_content "You need to sign in or sign up before continuing."
    expect(page).to_not have_link "Forgot your password?"

    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "letmein!!"
    click_button "Sign in"

    expect(page).to have_content "Your email/password combination was incorrect."

    fill_in "Email", with: admin.email
    fill_in "Password", with: admin.password
    click_button "Sign in"

    expect(page).to have_content "Admin dashboard"
  end
end
