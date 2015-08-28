require "rails_helper"

describe "Admin event management" do
  let(:year) { 1.year.from_now.year }

  before do
    FactoryGirl.create(:host, name: "Joe Bloggs")
    sign_in FactoryGirl.create(:admin)
    visit admin_events_path
  end

  scenario "admin creates, views, edits, and deletes an event" do
    # create
    click_link "Create new event"
    click_button "Create event"
    expect(page).to have_content "Please review the following errors"
    within(".event_title") { expect(page).to_not have_content "can't be blank" }
    within(".new_event") { expect(page).to have_content "Title can't be blank" }
    select "Joe Bloggs", from: "event_host_id"
    fill_in "event_date_date", with: "#{year}-01-01"
    fill_in "event_date_time", with: "19:00"
    fill_in "event_title", with: "Sunday Roast"
    fill_in "event_location", with: "London"
    fill_in "event_location_url", with: "http://example.com"
    fill_in "event_short_description", with: "The perfect end to the weekend"
    fill_in "event_description", with: "A *heart warming* Sunday Roast cooked behind decades of experience for the perfect meal"
    fill_in "event_menu", with: "- Pumpkin Soup\n- Roast Lamb with trimmings\n- Tiramisu"
    fill_in "event_seats", with: "8"
    fill_in "event_price", with: "10.00"
    expect(page).to_not have_field "event_slug"
    click_button "Create event"

    # index page
    expect(page).to have_content "Event successfully created"
    expect(page).to have_content "Sunday Roast"
    expect(page).to have_content "Joe Bloggs"

    # home page (thumbnail)
    visit root_path
    expect(page).to have_content "The perfect end to the weekend"

    # public event page
    click_link "Sunday Roast"
    expect(page).to have_content "Sunday Roast"
    expect(page).to have_content "Hosted by Joe Bloggs"
    expect(page).to_not have_link "Joe Bloggs"
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

    # show page
    visit admin_events_path
    click_link "Sunday Roast"
    expect(page).to have_content "Sunday Roast"
    expect(page).to have_content "Hosted by Joe Bloggs"
    expect(page).to have_content "London"
    expect(page).to have_content "1st January #{year} 7:00pm"
    expect(page).to have_content "8 seats"
    expect(page).to have_content "£10"
    expect(page).to have_content "The perfect end to the weekend"
    within(".description") do
      expect(page).to have_content "A heart warming Sunday Roast cooked behind decades of experience for the perfect meal"
    end
    within(".menu") do
      expect(page).to have_content "Pumpkin Soup"
      expect(page).to have_content "Roast Lamb with trimmings"
      expect(page).to have_content "Tiramisu"
    end
    expect(page).to_not have_link "Preview"
    expect(current_path).to eq "/admin/events/sunday-roast"
    expect(page).to_not have_link "Approve"

    # edit page
    click_link "Edit event"
    expect(page).to_not have_link "Approve"
    expect(page).to_not have_field "Pending event"
    fill_in "event_title", with: ""
    click_button "Save event"
    expect(page).to have_content "Please review the following errors"
    within(".event_title") { expect(page).to_not have_content "can't be blank" }
    within(".edit_event") { expect(page).to have_content "Title can't be blank" }
    fill_in "event_title", with: "Sunday Roast Lamb"
    click_button "Save event"
    expect(page).to have_content "Sunday Roast Lamb"

    # edit page slug
    click_link "Edit event"
    fill_in "event_slug", with: "sunday-roast-lamb"
    click_button "Save event"
    expect(page).to have_content "Event successfully updated"
    expect(current_path).to eq "/admin/events/sunday-roast-lamb"

    # delete
    click_link "Edit event"
    click_link "Delete event"
    expect(page).to have_content "Event successfully deleted"
    expect(page).to_not have_content "Sunday Roast Lamb"
    expect(current_path).to eq admin_events_path
    visit root_path
    expect(page).to_not have_content "Sunday Roast Lamb"
  end

  scenario "admin creates a pending event, previews and approves" do
    user = FactoryGirl.create(:user, first_name: "Joe", last_name: "Bloggs")
    FactoryGirl.create(:host, user: user, name: "Joeseph Bloggs")

    click_link "Create new event"
    fill_in_event_form
    select "Joeseph Bloggs", from: "event_host_id"
    attach_file "event_photos", [Rails.root.join("fixtures/carrierwave/image.png"), Rails.root.join("fixtures/carrierwave/image-1.png")]
    check "Pending event"
    click_button "Create event"

    within(".pending") { expect(page).to have_content "Sunday Roast" }
    click_link "Sunday Roast"
    click_link "Preview"

    within(".event-thumbnail") do
      expect(find("img.event-thumbnail__primary-photo")["src"]).to have_content "/assets/events/primary_default_thumb.png"
      expect(page).to have_content "Sunday Roast"
      expect(page).to have_content "1st January #{year} 7:00pm"
      expect(page).to have_content "£10"
      expect(page).to have_content "Londo"
      within(".event-thumbnail__short-description") do
        expect(page).to have_content "The perfect end to the weekend"
      end
    end

    within(".event-show") do
      expect(find("img.primary-photo")["src"]).to have_content "/assets/events/primary_default.png"
      expect(page).to have_content "Sunday Roast"
      expect(page).to have_content "Hosted by Joeseph Bloggs"
      expect(page).to have_link "Joeseph Bloggs", href: "/member/joe-bloggs"
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
      within(".photos") do
        path = %r(\/uploads\/events\/(\d)+\/photos\/(\h){32}.png)
        expect(find("img.photo-1")["src"]).to have_content path
        expect(find("img.photo-2")["src"]).to have_content path
        expect(find("img.photo-1")["src"]).to_not eq find("img.photo-2")["src"]
      end
    end

    click_link "Approve"
    expect(page).to have_content "Event successfully approved"
  end

  scenario "orders by the most recently created" do
    2.times do |number|
      click_link "Create new event"
      fill_in_event_form
      fill_in "event_title", with: "Event #{number + 1}"
      click_button "Create event"
    end

    expect("Event 2").to appear_before("Event 1")
  end

  scenario "admin sees events grouped by pending, approved, past events" do
    pending = FactoryGirl.create(:event, :pending)
    approved = FactoryGirl.create(:event)
    past = FactoryGirl.create(:event, date: 1.day.ago)

    visit admin_events_path
    within(".pending") { expect(page).to have_content pending.title }
    within(".approved") { expect(page).to have_content approved.title }
    within(".past") { expect(page).to have_content past.title }
  end

  scenario "admin creates an event with a primary photo" do
    click_link "Create new event"

    fill_in_event_form
    attach_file "eventPrimaryPhoto", Rails.root.join("fixtures/carrierwave/image.png")

    click_button "Create"
    click_link "Sunday Roast"

    click_link "Edit event"
    expect(find("img.event-primary-photo")["src"]).to_not have_content "/assets/events/primary_default.png"
    expect(find("img.event-primary-photo")["src"]).to have_content %r(\/uploads\/events\/(\d)+\/primary_photo\/(\h){32}.png)

    visit root_path
    expect(find("img.event-thumbnail__primary-photo")["src"]).to_not have_content "/assets/events/primary_default_thumb.png"
    expect(find("img.event-thumbnail__primary-photo")["src"]).to have_content %r(\/uploads\/events\/(\d)+\/primary_photo\/thumb_(\h){32}.png)

    visit "events/sunday-roast"
    expect(find("img.primary-photo")["src"]).to_not have_content "/assets/events/primary_default.png"
    expect(find("img.primary-photo")["src"]).to have_content %r(\/uploads\/events\/(\d)+\/primary_photo\/(\h){32}.png)
  end

  scenario "admin creates an event with additional photos" do
    click_link "Create new event"

    fill_in_event_form
    attach_file "event_photos", [Rails.root.join("fixtures/carrierwave/image.png")]

    click_button "Create"
    expect(page).to have_content "Please review the following errors"
    expect(page).to have_content "Photos uploaded must be a minimum of 2"

    attach_file "event_photos", [
      Rails.root.join("fixtures/carrierwave/image.png"),
      Rails.root.join("fixtures/carrierwave/image.png"),
      Rails.root.join("fixtures/carrierwave/image.png"),
      Rails.root.join("fixtures/carrierwave/image.png"),
      Rails.root.join("fixtures/carrierwave/image.png"),
      Rails.root.join("fixtures/carrierwave/image.png"),
      Rails.root.join("fixtures/carrierwave/image.png")
    ]

    click_button "Create"
    expect(page).to have_content "Please review the following errors"
    expect(page).to have_content "Photos uploaded must be a maximum of 6"

    attach_file "event_photos", [Rails.root.join("fixtures/carrierwave/image.png"), Rails.root.join("fixtures/carrierwave/image-1.png")]
    click_button "Create"
    click_link "Sunday Roast"

    click_link "Edit event"
    within(".event-photos") do
      path = %r(\/uploads\/events\/(\d)+\/photos\/(\h){32}.png)
      expect(find("img#photo-1")["src"]).to have_content path
      expect(find("img#photo-2")["src"]).to have_content path
      expect(find("img#photo-1")["src"]).to_not eq find("img#photo-2")["src"]
    end

    visit root_path
    click_link "Sunday Roast"
    within(".photos") do
      path = %r(\/uploads\/events\/(\d)+\/photos\/(\h){32}.png)
      expect(find("img.photo-1")["src"]).to have_content path
      expect(find("img.photo-2")["src"]).to have_content path
      expect(find("img.photo-1")["src"]).to_not eq find("img.photo-2")["src"]
    end
  end

  def fill_in_event_form
    select "Joe Bloggs", from: "event_host_id"
    fill_in "event_date_date", with: "#{year}-01-01"
    fill_in "event_date_time", with: "19:00"
    fill_in "event_title", with: "Sunday Roast"
    fill_in "event_location", with: "London"
    fill_in "event_location_url", with: "http://example.com"
    fill_in "event_short_description", with: "The perfect end to the weekend"
    fill_in "event_description", with: "A *heart warming* Sunday Roast cooked behind decades of experience for the perfect meal"
    fill_in "event_menu", with: "- Pumpkin Soup\n- Roast Lamb with trimmings\n- Tiramisu"
    fill_in "event_seats", with: "8"
    fill_in "event_price", with: "10.00"
  end
end
