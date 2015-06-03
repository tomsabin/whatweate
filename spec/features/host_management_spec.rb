require "rails_helper"

describe "host management" do
  before do
    sign_in FactoryGirl.create(:admin)
    visit admin_hosts_path
  end

  scenario "admin creates, views, edits and deletes a host" do
    FactoryGirl.create(:user, first_name: "Joseph", last_name: "Bloggs")

    click_link "Create new host"
    click_button "Create host"

    expect(page).to have_content "Please review the following errors"

    fill_in "host_name", with: "Joe Bloggs"
    click_button "Create host"

    expect(page).to have_content "Host successfully created"
    expect(page).to have_content "Joe Bloggs"

    click_link "Joe Bloggs"

    click_link "Edit host"
    fill_in "host_name", with: "Joe Bloggs"
    select "Joseph Bloggs", from: "host_profile_id"
    click_button "Save host"

    expect(page).to have_content "Host successfully updated"
    expect(page).to have_content "Joe Bloggs"
    expect(page).to have_content "User: Joseph Bloggs"

    click_link "Edit host"
    click_link "Delete host"

    expect(page).to have_content "Host successfully deleted"
    expect(page).to_not have_content "Joe Bloggs"
  end

  scenario "admin creates a host with associations and the User/Profile is removed" do
    FactoryGirl.create(:user, first_name: "Joseph", last_name: "Bloggs")

    click_link "Create new host"

    fill_in "host_name", with: "Joe Bloggs"
    select "Joseph Bloggs", from: "host_profile_id"

    click_button "Create host"

    User.find_by(first_name: "Joseph", last_name: "Bloggs").destroy

    click_link "Joe Bloggs"

    expect(page).to_not have_content "Profile: Joseph Bloggs"
  end

  scenario "orders by the most recently created" do
    click_link "Create new host"
    fill_in "host_name", with: "Joe Bloggs"
    click_button "Create host"

    click_link "Create new host"
    fill_in "host_name", with: "Zack Richardson"
    click_button "Create host"

    expect("Joe Bloggs").to appear_before "Zack Richardson"
  end
end
