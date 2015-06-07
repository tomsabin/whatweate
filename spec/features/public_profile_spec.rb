require "rails_helper"
include OmniauthHelpers

describe "Public profile" do
  scenario "user that has not completed their profile will not be publicly visible" do
    visit root_path
    click_link "Sign up"
    fill_in "Email", with: "user@example.com"
    fill_in "First name", with: "Cookie"
    fill_in "Last name", with: "Monster"
    fill_in "Password", with: "letmein!!"
    fill_in "Password confirmation", with: "letmein!!"
    click_button "Sign up"
    click_link "Sign out"

    visit profile_path(User.last)
    expect(page).to have_content "Looks like we can't find the page you were looking for"
  end
end
