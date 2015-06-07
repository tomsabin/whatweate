require "rails_helper"

describe "Host event" do
  scenario "guests tries to create an event" do
    sign_in FactoryGirl.create(:guest)
    expect(page).to_not have_link "Create an event"
    visit new_event_path
    expect(page).to have_content "Looks like we can't find the page you were looking for"
  end

  scenario "hosts creates an event" do
    sign_in FactoryGirl.create(:user, :host, first_name: "Joe", last_name: "Bloggs")
    click_link "Create an event"
    click_button "Submit event"
    # preview
    expect(page).to have_content "Please review the following errors"

    fill_in "event_date", with: "01/01/2000 19:00"
    fill_in "event_title", with: "Sunday Roast"
    fill_in "event_location", with: "Londo"
    fill_in "event_location_url", with: "http://example.com"
    fill_in "event_description", with: "A *heart warming* Sunday Roast cooked behind decades of experience for the perfect meal"
    fill_in "event_menu", with: "- Pumpkin Soup\n- Roast Lamb with trimmings\n- Tiramisu"
    fill_in "event_seats", with: "8"
    fill_in "event_price", with: "10.00"

    VCR.use_cassette("slack/host_event_submitted", match_requests_on: [:method, :host]) do
      expect(AdminMessenger).to receive(:broadcast).with("New event by Joe Bloggs has been submitted for approval").and_call_original
      click_button "Submit event"
    end

    expect(page).to have_content "Thanks, we will review your listing and your event will be ready soon"
  end
end