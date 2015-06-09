require "rails_helper"

describe "Guest event booking" do
  let(:user) { FactoryGirl.create(:user, email: "user@example.com") }

  context "seats are available" do
    let!(:event) { FactoryGirl.create(:event, title: "Event title", price_in_pennies: 2500) }

    scenario "user sees the payment prompt when JavaScript is enabled", :js do
      sign_in user
      visit root_path
      click_link event.title

      stripe_script = find(:xpath, ".//main//script[@src='https://checkout.stripe.com/checkout.js']", visible: false)
      expect(stripe_script["data-label"]).to eq "Book seat"
      expect(stripe_script["data-email"]).to eq "user@example.com"
      expect(stripe_script["data-name"]).to eq "WhatWeAte"
      expect(stripe_script["data-description"]).to eq "Event title"
      expect(stripe_script["data-amount"]).to eq "2500"
      expect(stripe_script["data-currency"]).to eq "GBP"
      click_button "Book seat"

      stripe_iframe = all("iframe[name=stripe_checkout_app]").last
      within_frame(stripe_iframe) do
        expect(page).to have_content "user@example.com"
        expect(page).to have_field "card_number"
        expect(page).to have_field "cc-exp"
        expect(page).to have_field "cc-csc"
        expect(page).to have_button "Pay £25.00"
      end
    end

    scenario "[smoke-test] user pays for the event booking when JavaScript is enabled", :js, :smoke do
      sign_in user
      visit root_path
      click_link event.title
      click_button "Book seat"

      sleep(2) # wait for modal to load :(
      stripe_iframe = all("iframe[name=stripe_checkout_app]").last
      within_frame(stripe_iframe) do
        expect(page).to have_content "user@example.com"
        fill_in "card_number", with: "4242424242424242"
        fill_in "cc-exp", with: "01/16"
        fill_in "cc-csc", with: "123"
        click_button "Pay £25.00"
        sleep(5) # wait for payment to process :'(
      end

      expect(page).to have_content "Thanks! We've booked you a seat."
      expect(current_url).to eq event_url(event)
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

    scenario "user is already signed up to the event prevents duplicate bookings" do
      Booking.create(event: event, user: user)

      sign_in user
      visit root_path
      click_link event.title
      expect(page).to have_content "You are booked on to this event"
    end
  end

  context "seats are full" do
    let!(:event) { FactoryGirl.create(:event, :sold_out, seats: 1, title: "Event title") }

    scenario "user cannot book onto a sold out event" do
      sign_in
      visit root_path
      click_link event.title
      expect(page).to have_button "Book seat", disabled: true
    end

    scenario "users that are going are displayed on the event page" do
      Booking.create(event: event, user: user)

      visit "events/event-title"
      within ".guests" do
        expect(page).to have_link "#{user.first_name} #{user.last_name}", href: member_path(user)
      end
    end
  end
end
