require "rails_helper"

describe "event management" do
  scenario "admin creates, views, edits and deletes an event" do
    visit admin_events_path

    click_link "Create new event"
    click_button "Create event"

    expect(page).to have_content "Please review the following errors"

    # select "Joe Bloggs", from: "event_host"
    fill_in "event_title", with: "Sunday Roast"
    fill_in "event_location", with: "London"
    fill_in "event_description", with: "A *heart warming* Sunday Roast cooked behind decades of experience for the perfect meal"
    fill_in "event_menu", with: "- Pumpkin Soup\n- Roast Lamb with trimmings\n- Tiramisu"
    fill_in "event_seats", with: "8"
    fill_in "event_price_in_pennies", with: "1000"
    expect(page).to have_field("event_currency", with: "GBP")
    click_button "Create event"

    expect(page).to have_content "Event successfully created"
    expect(page).to have_content "Sunday Roast"

    # visit root_path
    # click_link "Sunday Roast"

    # expect(page).to have_content "Sunday Roast"
    # expect(page).to have_content "Hosted by Joe Bloggs"
    # expect(page).to have_content "London"
    # expect(page).to have_content "8 seats"
    # expect(page).to have_content "£10"
    # expect(page).to have_content "A heart warming Sunday Roast cooked behind decades of experience for the perfect meal"
    # within("menu") do
    #   expect(page).to have_content "Pumpkin Soup"
    #   expect(page).to have_content "Roast Lamb with trimmings"
    #   expect(page).to have_content "Tiramisu"
    # end

    visit admin_events_path
    # click_link "'Sunday Roast' hosted by Joe Bloggs"
    click_link "Sunday Roast"

    expect(page).to have_content "Sunday Roast"
    # expect(page).to have_content "Hosted by Joe Bloggs"
    expect(page).to have_content "London"
    expect(page).to have_content "8 seats"
    expect(page).to have_content "£10"
    expect(page).to have_content "A heart warming Sunday Roast cooked behind decades of experience for the perfect meal"
    within("menu") do
      expect(page).to have_content "Pumpkin Soup"
      expect(page).to have_content "Roast Lamb with trimmings"
      expect(page).to have_content "Tiramisu"
    end

    click_button "Edit event"
    fill_in "event_title", with: "Sunday Roast Lamb"
    click_button "Save event"

    expect(page).to have_content "Event successfully updated"
    expect(page).to have_content "Sunday Roast Lamb"

    click_button "Delete event"

    expect(page).to have_content "Event successfully deleted"
    expect(page).to_not have_content "Sunday Roast Lamb"

    visit root_path

    expect(page).to_not have_content "Sunday Roast Lamb"
  end
end
