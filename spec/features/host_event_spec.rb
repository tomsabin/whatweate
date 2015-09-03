require "rails_helper"

describe "Host event" do
  scenario "guests tries to create an event" do
    sign_in FactoryGirl.create(:guest)
    expect(page).to_not have_link "Create an event"
    visit new_event_path
    expect(page).to have_content "Looks like we can't find the page you were looking for"
  end

  scenario "hosts creates an event and admin approves the event" do
    sign_in FactoryGirl.create(:user, :host, first_name: "Joe", last_name: "Bloggs")
    click_link "Create an event"
    click_button "Submit event"

    expect(page).to have_content "Please review the following errors"
    within(".event_title") { expect(page).to have_content "can't be blank" }

    fill_in "event_date_date", with: "01/01/#{1.year.from_now.year}"
    fill_in "event_date_time", with: "19:00"
    fill_in "event_title", with: "Sunday Roast"
    fill_in "event_location", with: "London"
    fill_in "event_location_url", with: "http://example.com"
    fill_in "event_short_description", with: "The perfect end to the weekend"
    fill_in "event_description", with: "A *heart warming* Sunday Roast cooked behind decades of experience for the perfect meal"
    fill_in "event_menu", with: "- Pumpkin Soup\n- Roast Lamb with trimmings\n- Tiramisu"
    fill_in "event_seats", with: "8"
    fill_in "event_price", with: "10.00"

    VCR.use_cassette("slack/host_event_submitted", match_requests_on: [:method, :host]) do
      expect(AdminMessenger).to receive(:broadcast)
        .with("New event by Joe Bloggs has been submitted for approval: #{admin_event_url("sunday-roast")}").and_call_original
      click_button "Submit event"
    end

    expect(page).to have_content "Thanks, we will review your listing and your event will be ready soon"

    visit root_path

    expect(page).to_not have_link "Sunday Roast"

    sign_in FactoryGirl.create(:admin)
    visit admin_event_path(Event.last)
    click_link "Approve"

    visit root_path

    within(".event-thumbnail") do
      expect(find("img.event-thumbnail__primary-photo")["src"]).to have_content "/assets/events/primary_default_thumb.png"
      expect(page).to have_content "The perfect end to the weekend"
    end

    click_link "Sunday Roast"

    expect(find("img.event-show__primary-photo")["src"]).to have_content "/assets/events/primary_default.png"
    expect(page).to have_link "Joe Bloggs"
    expect(page).to have_link "London", href: "http://example.com"
    expect(page.find_link("London")["target"]).to have_content "_blank"
    expect(page).to_not have_button "Book seat"
    expect(page).to have_content "This is your own event"
  end

  xscenario "host views their thumbnail preview (text) being built up", :js do
    sign_in FactoryGirl.create(:user, :host, first_name: "Joe", last_name: "Bloggs")
    click_link "Create an event"

    within(".event-thumbnail") do
      expect(find("img.event-thumbnail__primary-photo")["src"]).to have_content "/assets/events/primary_default_thumb.png"
      expect(page).to have_content "Event title"
      expect(page).to have_content "£30"
      expect(page).to have_content "Your description here"
      expect(page).to have_content "London"
    end

    fill_in "event_date_date", with: "01/01/2000"
    fill_in "event_date_time", with: "19:00"
    fill_in "event_title", with: "Sunday Roast"
    fill_in "event_location", with: "Old Street, London"
    fill_in "event_short_description", with: "The perfect end to the weekend"
    fill_in "event_price", with: "10.50"

    within(".event-thumbnail") do
      expect(page).to have_content "Sunday Roast"
      expect(page).to have_content "£10.50"
      expect(page).to have_content "1st January 2000 7:00pm"
      expect(page).to have_content "The perfect end to the weekend"
      expect(page).to have_content "Old Street, London"
    end
  end

  xscenario "host views their thumbnail preview (image) being built up", :js do
    sign_in FactoryGirl.create(:user, :host, first_name: "Joe", last_name: "Bloggs")
    click_link "Create an event"

    within(".event-thumbnail") do
      expect(find("img.event-show__primary-photo")["src"]).to have_content "/assets/events/primary_default_thumb.png"
    end

    attach_file "eventPrimaryPhoto", Rails.root.join("fixtures/carrierwave/image.png")

    within(".event-thumbnail") do
      find("img.event-show__primary-photo")["src"] # wait for image src to be replaced
      expect(find("img.event-show__primary-photo")["src"]).to_not have_content "/assets/events/primary_default_thumb.png"
    end
  end

  scenario "host creates an event with a primary photo" do
    sign_in FactoryGirl.create(:user, :host, first_name: "Joe", last_name: "Bloggs")
    click_link "Create an event"

    fill_in_event_form
    fill_in "event_title", with: ""
    attach_file "eventPrimaryPhoto", Rails.root.join("fixtures/carrierwave/image.png")

    click_button "Submit event"
    fill_in "event_title", with: "Sunday Roast"

    VCR.use_cassette("slack/host_event_submitted", match_requests_on: [:method, :host]) do
      click_button "Submit event"
    end
    expect(page).to have_content "Thanks, we will review your listing and your event will be ready soon"

    approve_last_event!

    visit root_path
    expect(find("img.event-thumbnail__primary-photo")["src"]).to_not have_content "/assets/events/primary_default_thumb.png"
    path = %r(\/uploads\/events\/(\d)+\/primary_photo\/thumb_(\h){32}.png)
    expect(find("img.event-thumbnail__primary-photo")["src"]).to have_content path

    click_link "Sunday Roast"
    expect(find("img.event-show__primary-photo")["src"]).to_not have_content "/assets/events/primary_default.png"
    path = %r(\/uploads\/events\/(\d)+\/primary_photo\/(\h){32}.png)
    expect(find("img.event-show__primary-photo")["src"]).to have_content path
  end

  scenario "host creates an event with additional photos" do
    sign_in FactoryGirl.create(:user, :host, first_name: "Joe", last_name: "Bloggs")
    click_link "Create an event"

    fill_in_event_form
    attach_file "eventPhotos", [Rails.root.join("fixtures/carrierwave/image.png")]

    click_button "Submit event"
    expect(page).to have_content "Please review the following errors"
    within(".event_photos") { expect(page).to have_content "uploaded must be a minimum of 2" }

    attach_file "eventPhotos", [Rails.root.join("fixtures/carrierwave/image.png"), Rails.root.join("fixtures/carrierwave/image-1.png")]
    fill_in "event_title", with: ""

    click_button "Submit event"
    expect(page).to have_css("#eventPhotoContainer img", count: 2)

    fill_in "event_title", with: "Sunday Roast"

    VCR.use_cassette("slack/host_event_submitted", match_requests_on: [:method, :host]) do
      click_button "Submit event"
    end
    expect(page).to have_content "Thanks, we will review your listing and your event will be ready soon"

    approve_last_event!
    visit root_path
    click_link "Sunday Roast"

    within(".event-show__photo-gallery") do
      path = %r(\/uploads\/events\/(\d)+\/photos\/(\h){32}.png)
      expect(find("img[@data-index='0']")["src"]).to have_content path
      expect(find("img[@data-index='1']")["src"]).to have_content path
      expect(find("img[@data-index='0']")["src"]).to_not eq find("img[@data-index='1']")["src"]
    end
  end

  xscenario "host previews the primary image before creating the event", :js do
    # move to more reliable test (isolate JS and test using JS test framework)

    sign_in FactoryGirl.create(:user, :host, first_name: "Joe", last_name: "Bloggs")
    click_link "Create an event"

    within(".event-thumbnail") do
      expect(find("img.event-show__primary-photo")["src"]).to have_content "/assets/events/primary_default_thumb.png"
    end

    attach_file "eventPrimaryPhoto", Rails.root.join("fixtures/carrierwave/image.png")

    within(".event-thumbnail") do
      find("img.event-show__primary-photo")["src"] # wait for image src to be replaced
      expect(find("img.event-show__primary-photo")["src"]).to_not have_content "/assets/events/primary_default_thumb.png"
    end
  end

  scenario "host previews the additional images before creating the event", :js do
    sign_in FactoryGirl.create(:user, :host, first_name: "Joe", last_name: "Bloggs")
    click_link "Create an event"

    expect(page).to have_css("#eventPhotoContainer img", count: 0)
    attach_file "eventPhotos", [Rails.root.join("fixtures/carrierwave/image.png"), Rails.root.join("fixtures/carrierwave/image-1.png")]
    expect(page).to have_css("#eventPhotoContainer img", count: 2)
  end

  def fill_in_event_form
    fill_in "event_date_date", with: "01/01/#{1.year.from_now.year}"
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

  def approve_last_event!
    Event.last.approve!
  end
end
