require "rails_helper"

describe "Guest event booking" do
  let(:attendee) { FactoryGirl.create(:user) }

  context "seats are available" do
    let!(:event) { FactoryGirl.create(:event) }

    scenario "user books a seat when JavaScript is enabled", js: true do
      sign_in
      visit root_path
      click_link event.title
      click_button "Book seat"
      # payment
      expect(page).to have_content "Thanks! We've booked you a seat"

      # expect(current_url).to eq event_url(event)
      # expect(page).to_not have_button "Book seat"
    end

    scenario "user is prompted to sign in before making a booking" do
      visit root_path
      click_link event.title
      click_button "Book seat"
      expect(page).to have_content "You need to sign in or sign up before continuing"
    end

    scenario "user is prompted to turn on JavaScript for booking a seat" do
      sign_in
      click_link event.title
      click_button "Book seat"
      expect(page).to have_content "Please enable JavaScript for our payment system to work"
    end

    scenario "user is prompted to complete their profile before making a booking" do
      sign_in FactoryGirl.create(:user_without_profile)
      visit root_path
      click_link event.title
      click_button "Book seat"
      expect(page).to have_content "Please complete your profile."
    end

    scenario "attendee is already signed up to the event prevents duplicate bookings" do
      Booking.create(event: event, user: attendee)

      sign_in attendee
      visit root_path
      click_link event.title
      click_button "Book seat"
      expect(page).to have_content "You are already booked on this event"
    end
  end

  context "seats are full" do
    let!(:event) { FactoryGirl.create(:event, :sold_out, seats: 1, title: "Event title") }

    scenario "user cannot book onto a sold out event" do
      sign_in
      visit root_path
      click_link event.title
      click_button "Book seat"
      expect(page).to have_content "Sorry, this event has sold out"
    end

    scenario "attendees that are going are displayed on the event page" do
      Booking.create(event: event, user: attendee)

      visit "events/event-title"
      within ".guests" do
        expect(page).to have_link "#{attendee.first_name} #{attendee.last_name}", href: member_path(attendee)
      end
    end
  end
end
