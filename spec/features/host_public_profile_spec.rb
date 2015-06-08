require "rails_helper"

describe "Host public profile" do
  scenario "visits a host" do
    host = FactoryGirl.create(:host, name: "Joe Bloggs")
    FactoryGirl.create(:event, host: host, title: "Upcoming event")
    FactoryGirl.create(:event, host: host, title: "Past event", date: 1.day.ago)
    FactoryGirl.create(:event, title: "Other event")

    visit "host/joe-bloggs"
    expect(page).to have_content "Joe Bloggs"

    within(".upcoming-events") do
      expect(page).to have_link "Upcoming event"
      expect(page).to_not have_link "Past event"
      expect(page).to_not have_link "Other event"
    end

    within(".past-events") do
      expect(page).to_not have_link "Upcoming event"
      expect(page).to have_link "Past event"
      expect(page).to_not have_link "Other event"
    end
  end
end
