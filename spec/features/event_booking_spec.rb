require "rails_helper"

describe "Event booking" do

  context "seats are available" do
    let!(:event) { FactoryGirl.create(:available_event) }

    scenario "user signs up to the event" do
      visit root_path
      click_link event.title
      click_button "Book seat"
      expect(page).to have_content "You need to sign in or sign up before continuing"

      sign_in
      click_button "Book seat"
      expect(page).to have_content "Thanks! We've booked you a seat"

      expect(current_url).to eq event_url(event)
      expect(page).to_not have_button "Book seat"
    end
  end

  context "seats are full" do
    let!(:event) { FactoryGirl.create(:sold_out_event) }

    scenario "user can request a new date of the event"
  end

end
