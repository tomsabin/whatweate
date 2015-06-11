require "rails_helper"

describe "Admin host management" do
  before do
    sign_in FactoryGirl.create(:admin)
    visit admin_hosts_path
  end

  scenario "admin creates, views, edits and deletes a host" do
    user = FactoryGirl.create(:user, first_name: "Joseph", last_name: "Bloggs")

    click_link "Create new host"
    click_button "Create host"

    expect(page).to have_content "Please review the following errors"
    within(".host_name") { expect(page).to_not have_content "can't be blank" }
    within(".new_host") { expect(page).to have_content "Name can't be blank" }

    fill_in "host_name", with: "Joe Bloggs"
    click_button "Create host"

    expect(page).to have_content "Host successfully created"
    expect(page).to have_content "Joe Bloggs"

    click_link "Joe Bloggs"

    click_link "Edit host"
    fill_in "host_name", with: ""
    click_button "Save host"

    expect(page).to have_content "Please review the following errors"
    within(".host_name") { expect(page).to_not have_content "can't be blank" }
    within(".edit_host") { expect(page).to have_content "Name can't be blank" }

    fill_in "host_name", with: "Joe Bloggs"
    select "Joseph Bloggs", from: "host_user_id"
    click_button "Save host"

    expect(page).to have_content "Host successfully updated"
    expect(page).to have_content "Joe Bloggs"
    expect(page).to have_link "Joseph Bloggs", href: member_path(user)

    click_link "Edit host"
    click_link "Delete host"

    expect(page).to have_content "Host successfully deleted"
    expect(page).to_not have_content "Joe Bloggs"
  end

  scenario "admin creates a host with associations and the user is notified" do
    FactoryGirl.create(:user, first_name: "Joseph", last_name: "Bloggs")

    click_link "Create new host"

    fill_in "host_name", with: "Joe Bloggs"
    select "Joseph Bloggs", from: "host_user_id"

    click_button "Create host"

    expect(ActionMailer::Base.deliveries.last.subject).to eq "New host"
  end

  scenario "admin creates a host with associations and the User/Profile is removed" do
    FactoryGirl.create(:user_without_profile, first_name: "Zack", last_name: "Richardson")
    FactoryGirl.create(:user, first_name: "Joseph", last_name: "Bloggs")

    click_link "Create new host"

    fill_in "host_name", with: "Joe Bloggs"
    expect(page).to have_select("host_user_id", options: ["", "Joseph Bloggs"])
    select "Joseph Bloggs", from: "host_user_id"

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

  scenario "admin tries to delete a Host that has an event" do
    host = FactoryGirl.create(:host, name: "Joe Bloggs")
    FactoryGirl.create(:event, host: host)

    visit admin_hosts_path
    click_link "Joe Bloggs"
    click_link "Edit host"
    click_link "Delete host"

    expect(page).to_not have_content "Host successfully deleted"
    expect(page).to have_content "Cannot delete record because dependent events exist"
  end

  scenario "admin does not see users that are already hosts in select" do
    FactoryGirl.create(:user, first_name: "Joe", last_name: "Bloggs")
    FactoryGirl.create(:user, first_name: "Zack", last_name: "Richardson")

    click_link "Create new host"

    expect(page).to have_select("host_user_id", options: ["", "Joe Bloggs", "Zack Richardson"])

    select "Joe Bloggs", from: "host_user_id"
    fill_in "host_name", with: "Joe Bloggs"
    click_button "Create host"
    click_link "Joe Bloggs"
    click_link "Edit host"

    expect(page).to have_select("host_user_id", options: ["", "Joe Bloggs", "Zack Richardson"])

    visit admin_hosts_path
    click_link "Create new host"

    expect(page).to have_select("host_user_id", options: ["", "Zack Richardson"])
  end
end
