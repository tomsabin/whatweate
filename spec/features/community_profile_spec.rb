require "rails_helper"

describe "community profile" do
  scenario "two users send messages to one another" do
    recipient = FactoryGirl.create(:user, first_name: "Recipient")
    sender = FactoryGirl.create(:user, first_name: "Sender")

    sign_in sender
    visit member_path(recipient.profile)

    click_link "Send message"

    expect(page).to have_content "From: Sender"
    expect(page).to have_content "To: Recipient"

    click_button "Send"

    within(".message_body") { expect(page).to have_content "can't be blank"}
    fill_in "message_body", with: "Hello"
    click_button "Send"

    expect(page).to have_content "Message was successfully sent"
    expect(page).to have_content "Conversation with Recipient"
    expect(page).to have_content "Hello"

    click_link "Messages"

    expect(page).to have_content "Recipient"
    expect(page).to have_content "Hello"

    click_link "Sign out"
    sign_in recipient

    expect(page).to have_content "Messages (1)"

    click_link "Messages (1)"

    expect(page).to have_content "Sender"
    expect(page).to have_content "(unread) Hello"

    click_link "(unread) Hello"

    expect(page).to_not have_content "Messages (1)"
    expect(page).to have_content "Conversation with Sender"

    click_button "Send"

    within(".message_body") { expect(page).to have_content "can't be blank"}
    fill_in "message_body", with: "Hi"
    click_button "Send"

    expect(page).to have_content "Message was successfully sent"
    expect(page).to have_content "Conversation with Recipient"
    expect(page).to have_content "Hello"
    expect(page).to have_content "Hi"

    visit member_path(sender.profile)

    click_link "Send message"

    expect(page).to have_content "From: Recipient"
    expect(page).to have_content "To: Sender"
    fill_in ".message_body", with: "How are you?"
    click_button "Send"

    expect(page).to have_content "Message was successfully sent"
    expect(page).to have_content "Conversation with Recipient"
    expect(page).to have_content "Hello"
    expect(page).to have_content "Hi"
    expect(page).to have_content "How are you?"
  end

  xscenario "user sends message to an event page" do
  end
end
