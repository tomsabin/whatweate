require "rails_helper"

describe "Admins" do
  let(:admin) { FactoryGirl.create(:admin) }

  scenario "signs in to dashboard" do
    visit admin_root_path

    expect(page).to have_content "You need to sign in or sign up before continuing."
    expect(page).to_not have_link "Forgot your password?"

    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "letmein!!"
    click_button "Log in"

    expect(page).to have_content "Your email/password combination was incorrect."

    fill_in "Email", with: admin.email
    fill_in "Password", with: admin.password
    click_button "Log in"

    expect(page).to have_content "Dashboard"
    within(".nav-wrapper .active", match: :first) { expect(page).to have_content "Events" }

    click_link "Home", match: :first
    expect(current_path).to eq root_path
  end

  scenario "signing out of admin persists user sign in" do
    sign_in FactoryGirl.create(:user)
    sign_in admin

    visit user_path
    expect(page).to have_link "Profile"

    visit admin_root_path
    expect(page).to have_link "Dashboard"

    click_link "Sign out"
    expect(page).to have_link "Profile"
  end

  scenario "signing out of user persists admin sign in" do
    sign_in FactoryGirl.create(:user)
    sign_in admin

    visit admin_root_path
    expect(page).to have_link "Dashboard"

    visit user_path
    expect(page).to have_link "Profile"

    click_link "Log out"
    visit admin_root_path
    expect(page).to have_link "Dashboard"
  end
end
