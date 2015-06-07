require "rails_helper"

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

    visit member_path(User.last)
    expect(page).to have_content "Looks like we can't find the page you were looking for"
  end

  scenario "visits a profile with default visibility options" do
    user = FactoryGirl.create(:user, date_of_birth: Date.new(1980, 1, 1))
    visit member_path(user)

    expect(page).to_not have_content user.email
    expect(page).to have_content user.first_name
    expect(page).to have_content user.last_name
    expect(page).to_not have_content "1st January 1980"
    expect(page).to have_content user.profession
    expect(page).to have_content user.greeting
    expect(page).to have_content user.bio
    expect(page).to_not have_content user.mobile_number
    expect(page).to have_content user.favorite_cuisine
    expect(page).to_not have_content "Verified with Facebook"
    expect(page).to_not have_content "Verified with Twitter"
  end

  scenario "visits a profile with all-visible options" do
    user = FactoryGirl.create(:user, date_of_birth: Date.new(1985, 5, 2), date_of_birth_visible: true, mobile_number_visible: true)
    visit member_path(user)

    expect(page).to_not have_content user.email
    expect(page).to have_content "2nd May 1985"
    expect(page).to have_content user.mobile_number
  end

  scenario "visits a profile with verified social networks" do
    user = FactoryGirl.create(:user, :facebook, :twitter)
    visit member_path(user)

    expect(page).to have_content "Verified with Facebook"
    expect(page).to have_content "Verified with Twitter"
  end
end
