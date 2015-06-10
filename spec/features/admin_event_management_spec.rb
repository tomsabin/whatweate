require "rails_helper"

describe "Admin event management" do
  let(:year) { 1.year.from_now.year }

  before do
    FactoryGirl.create(:host, name: "Joe Bloggs")
    sign_in FactoryGirl.create(:admin)
    visit admin_events_path
  end

  scenario "admin previews and creates, views, previews and edits, and deletes an event" do
    click_link "Create new event"
    click_button "Create event"

    expect(page).to have_content "Please review the following errors"
    within(".event_title") { expect(page).to_not have_content "can't be blank" }
    within(".new_event") { expect(page).to have_content "Title can't be blank" }

    select "Joe Bloggs", from: "event_host_id"
    fill_in "event_date", with: "01/01/#{year} 19:00"
    fill_in "event_title", with: "Sunday Roast"
    fill_in "event_location", with: "Londo"
    fill_in "event_location_url", with: "http://example.com"
    fill_in "event_description", with: "A *heart warming* Sunday Roast cooked behind decades of experience for the perfect meal"
    fill_in "event_menu", with: "- Pumpkin Soup\n- Roast Lamb with trimmings\n- Tiramisu"
    fill_in "event_seats", with: "8"
    fill_in "event_price", with: "10.00"
    click_button "Preview"

    expect(page).to have_content "Sunday Roast"
    expect(page).to have_content "Hosted by Joe Bloggs"
    expect(page).to have_link "View on map"
    expect(page).to have_content "1st January #{year} 7:00pm"
    expect(find_link("View on map")[:href]).to eq "http://example.com"
    expect(page).to have_content "Londo"
    expect(page).to have_content "£10"
    within(".description") do
      expect(page).to have_content "A heart warming Sunday Roast cooked behind decades of experience for the perfect meal"
    end
    within(".menu") do
      expect(page).to have_content "Pumpkin Soup"
      expect(page).to have_content "Roast Lamb with trimmings"
      expect(page).to have_content "Tiramisu"
    end

    expect(page).to have_button "Create event"
    click_link "Edit"
    fill_in "event_location", with: "London"
    click_button "Create event"

    expect(page).to have_content "Event successfully created"
    expect(page).to have_content "Sunday Roast"

    visit root_path
    click_link "Sunday Roast"

    expect(page).to have_content "Sunday Roast"
    expect(page).to have_content "Hosted by Joe Bloggs"
    expect(page).to have_link "View on map"
    expect(page).to have_content "1st January #{year} 7:00pm"
    expect(find_link("View on map")[:href]).to eq "http://example.com"
    expect(page).to have_content "London"
    expect(page).to have_button "Book seat"
    expect(page).to have_content "£10"
    within(".description") do
      expect(page).to have_content "A heart warming Sunday Roast cooked behind decades of experience for the perfect meal"
    end
    within(".menu") do
      expect(page).to have_content "Pumpkin Soup"
      expect(page).to have_content "Roast Lamb with trimmings"
      expect(page).to have_content "Tiramisu"
    end

    visit admin_events_path
    expect(page).to have_content "Sunday Roast"
    expect(page).to have_content "Joe Bloggs"
    click_link "Sunday Roast"

    expect(page).to have_content "Sunday Roast"
    expect(page).to have_content "Hosted by Joe Bloggs"
    expect(page).to have_content "London"
    expect(page).to have_content "1st January #{year} 7:00pm"
    expect(page).to have_content "8 seats"
    expect(page).to have_content "£10"
    within(".description") do
      expect(page).to have_content "A heart warming Sunday Roast cooked behind decades of experience for the perfect meal"
    end
    within(".menu") do
      expect(page).to have_content "Pumpkin Soup"
      expect(page).to have_content "Roast Lamb with trimmings"
      expect(page).to have_content "Tiramisu"
    end

    click_link "Edit event"

    fill_in "event_title", with: ""
    click_button "Save event"

    expect(page).to have_content "Please review the following errors"
    within(".event_title") { expect(page).to_not have_content "can't be blank" }
    within(".edit_event") { expect(page).to have_content "Title can't be blank" }

    fill_in "event_title", with: "Sunday Roast Lamb"
    click_button "Save event"

    expect(page).to have_content "Event successfully updated"
    expect(page).to have_content "Sunday Roast Lamb"
    expect(page).to_not have_link "Approve"

    click_link "Edit event"
    expect(page).to_not have_link "Approve"
    click_link "Delete event"

    expect(page).to have_content "Event successfully deleted"
    expect(page).to_not have_content "Sunday Roast Lamb"

    expect(current_path).to eq admin_events_path

    visit root_path

    expect(page).to_not have_content "Sunday Roast Lamb"
  end

  scenario "orders by the most recently created" do
    2.times do |number|
      click_link "Create new event"
      select "Joe Bloggs", from: "event_host_id"
      fill_in "event_date", with: "01/01/2000 19:00"
      fill_in "event_title", with: "Event #{number + 1}"
      fill_in "event_location", with: "London"
      fill_in "event_location_url", with: "https://example.com"
      fill_in "event_description", with: "Description"
      fill_in "event_menu", with: "Menu"
      fill_in "event_price", with: "10.00"
      click_button "Create event"
    end

    expect("Event 2").to appear_before("Event 1")
  end

  scenario "admin approves a pending event" do
    FactoryGirl.create(:event, :pending, title: "Event title")
    visit admin_events_path
    click_link "Event title"
    click_link "Approve"
    expect(page).to have_content "Event successfully approved"
  end

  scenario "admin sees events grouped by pending, approved, past events" do
    pending = FactoryGirl.create(:event, :pending)
    approved = FactoryGirl.create(:event)
    past = FactoryGirl.create(:event, date: 1.day.ago)

    visit admin_events_path
    within('.pending') { expect(page).to have_content pending.title }
    within('.approved') { expect(page).to have_content approved.title }
    within('.past') { expect(page).to have_content past.title }
  end
end
