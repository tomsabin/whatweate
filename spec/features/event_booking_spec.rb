require "rails_helper"

describe "Event booking" do
  context "seats are available" do
    let!(:event) { FactoryGirl.create(:event) }

    scenario "user signs up to the event" do
      visit root_path
      click_link event.title
      click_button "Book seat"
      expect(page).to have_content "You need to sign in or sign up before continuing"

      sign_in
      click_button "Book seat"
      expect(page).to have_content "Thanks! We've booked you a seat"

      click_button "Book seat"
      expect(page).to have_content "You are already booked on this event"

      # expect(current_url).to eq event_url(event)
      # expect(page).to_not have_button "Book seat"
    end
  end

  context "seats are full" do
    let!(:attendee) { FactoryGirl.create(:user) }
    let!(:event) { FactoryGirl.create(:event, seats: 1) }
    let!(:user) { FactoryGirl.create(:user) }

    before do
      sign_in attendee
      visit root_path
      click_link event.title
      click_button "Book seat"
      expect(page).to have_content "Thanks! We've booked you a seat"
      click_link "Sign out"
    end

    scenario "user tries to get a seat to a sold out event" do
      sign_in user
      visit root_path
      click_link event.title
      click_button "Book seat"
      expect(page).to have_content "Sorry, this event has sold out"
    end

    xscenario "user can request a new date of the event" do
      visit root_path
      click_link event.title
      expect(page).to_not have_button "Book seat"
      click_button have_button "Request date"
      expect(page).to have_content "You need to sign in or sign up before continuing"

      sign_in
      click_button "Request date"
      fill_in "event_message", with: "Please could you rehost this on 1st January?"
      click_button "Send"
    end
  end
end
