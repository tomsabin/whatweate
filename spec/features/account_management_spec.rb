require "rails_helper"
include OmniauthHelpers

describe "Account management" do
  scenario "guest signs up from the homepage, signs out and then completes their profile" do
    visit root_path
    click_link "Sign up"
    click_button "Sign up"

    expect(page).to have_content "Please review the following errors"
    within(".user_email") { expect(page).to have_content "can't be blank" }

    fill_in "Email", with: "user@example.com"
    fill_in "First name", with: "Cookie"
    fill_in "Last name", with: "Monster"
    fill_in "Password", with: "letmein!!"
    fill_in "Password confirmation", with: "letmein!!"
    click_button "Sign up"

    expect(page).to have_content "Please complete your profile"

    click_link "Log out"

    visit root_path
    click_link "Log in"
    click_button "Log in"

    within(".user_email") { expect(page).to_not have_content "can't be blank" }
    expect(page).to_not have_content "Please review the following errors"
    expect(page).to have_content "Your email/password combination was incorrect"

    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "letmein!!"
    click_button "Log in"

    expect(page).to_not have_content "Signed in successfully"
    expect(page).to have_field "user_email", with: "user@example.com"
    expect(page).to have_field "user_first_name", with: "Cookie"
    expect(page).to have_field "user_last_name", with: "Monster"
    expect(page).to have_content "Please complete your profile"

    click_button "Save profile"
    expect(page).to have_content "Please review the following errors"

    fill_in "user_date_of_birth", with: "1990-06-18"
    expect(page).to have_field "user_date_of_birth_visible", checked: false
    fill_in "user_profession", with: "Cookie monster"
    fill_in "user_greeting", with: "Cookies cookies cookies"
    fill_in "user_bio", with: "I like cookies"
    fill_in "user_mobile_number", with: "0123456789"
    expect(page).to have_field "user_mobile_number_visible", checked: false
    fill_in "user_favorite_cuisine", with: "Chocolate"
    expect(page).to_not have_field "user_slug"

    click_button "Save profile"
    expect(page).to have_content "Your profile has successfully been saved"
    expect(page).to have_content "Cookie Monster"

    expect(page).to have_content "user@example.com"
    expect(page).to have_content "18th June 1990 (not publicly visible)"
    expect(page).to have_content "Cookie monster"
    expect(page).to have_content "Cookies cookies cookies"
    expect(page).to have_content "I like cookies"
    expect(page).to have_content "0123456789 (not publicly visible)"
    expect(page).to have_content "Chocolate"
  end

  context "as a user that has completed their profile" do
    before { FactoryGirl.create(:user, email: "user@example.com", password: "letmein!!") }

    scenario "forgets their password" do
      visit root_path
      click_link "Log in"
      click_button "Log in"

      expect(page).to have_content "Your email/password combination was incorrect"

      click_link "Forgot your password?"
      click_button "Send me password reset instructions"
      within(".user_email") { expect(page).to have_content "can't be blank" }

      fill_in "user_email", with: "user@example.com"
      click_button "Send me password reset instructions"

      expect(ActionMailer::Base.deliveries.last.subject).to eq "Reset password instructions"
      visit edit_user_password_path(reset_password_token)

      click_button "Change my password"
      expect(page).to have_content "Please review the following errors"
      expect(page).to have_content "Password can't be blank"

      fill_in "user_password", with: "newpassword"
      fill_in "user_password_confirmation", with: "newpassword"
      click_button "Change my password"

      expect(page).to have_content "Your password has been changed successfully. You are now signed in."

      click_link "Log out"
      click_link "Log in"

      fill_in "user_email", with: "user@example.com"
      fill_in "user_password", with: "newpassword"
      click_button "Log in"

      expect(page).to have_content "Signed in successfully"
      expect(page).to_not have_content "Please complete your profile"
    end

    def reset_password_token
      { reset_password_token: ActionMailer::Base.deliveries.last.body.raw_source.match(/reset_password_token=(.*)\"/)[1] }
    end

    context "having successfully signed in" do
      before(:each) do
        visit root_path
        click_link "Log in"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "letmein!!"
        click_button "Log in"
      end

      scenario "updates their profile" do
        click_link "Dashboard"
        click_link "Edit profile"

        fill_in "user_email", with: "invalid"
        fill_in "user_date_of_birth", with: ""

        click_button "Save profile"

        expect(page).to have_content "Please review the following errors"
        within(".user_email") { expect(page).to have_content "is invalid" }
        within(".user_date_of_birth") { expect(page).to have_content "can't be blank" }

        fill_in "user_email", with: "me@cookie.com"
        fill_in "user_first_name", with: "Cookie"
        fill_in "user_last_name", with: "Monster"
        fill_in "user_date_of_birth", with: "1990-06-18"
        check "user_date_of_birth_visible"
        fill_in "user_profession", with: "Cookie monster"
        fill_in "user_bio", with: "I like cookies"
        fill_in "user_greeting", with: "Cookies cookies cookies"
        fill_in "user_mobile_number", with: "0123456789"
        check "user_mobile_number_visible"
        fill_in "user_favorite_cuisine", with: "Chocolate"

        click_button "Save profile"
        expect(page).to have_content "Your profile has successfully been saved"
        expect(page).to have_content "Cookie Monster"

        expect(page).to have_content "me@cookie.com"
        expect(page).to have_content "18th June 1990"
        expect(page).to have_content "Cookie monster"
        expect(page).to have_content "I like cookies"
        expect(page).to have_content "Cookies cookies cookies"
        expect(page).to have_content "0123456789"
        expect(page).to have_content "Chocolate"

        click_link "Edit profile"
        expect(page).to have_field "user_date_of_birth", with: "1990-06-18"
      end

      scenario "user updates their password" do
        click_link "Dashboard"
        click_link "Edit profile"
        click_link "Change your password", match: :first

        fill_in "user_current_password", with: "this-is-not-my-password"
        fill_in "user_password", with: "newpassword"
        fill_in "user_password_confirmation", with: "newpassword"
        click_button "Update password"

        within(".user_current_password") { expect(page).to have_content "was incorrect" }

        fill_in "user_current_password", with: "letmein!!"
        fill_in "user_password", with: "newpassword"
        fill_in "user_password_confirmation", with: "newpassword"
        click_button "Update password"

        expect(page).to have_content "Your password has been changed successfully"

        click_link "Log out"
        click_link "Log in"

        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "letmein!!"
        click_button "Log in"

        expect(page).to have_content "Your email/password combination was incorrect"

        fill_in "Password", with: "newpassword"
        click_button "Log in"

        expect(page).to have_content "Signed in successfully"
      end

      scenario "deletes their account" do
        click_link "Dashboard"
        click_link "Edit profile"
        click_link "Delete your account", match: :first

        expect(page).to have_content "Are you sure you want to delete your account?"
        expect(page).to have_link "No, cancel"
        click_link "Yes, delete my account"

        expect(current_path).to eq root_path

        expect(page).to have_content "Your account has been successfully been deleted. We hope to see you again soon"

        click_link "Log in"

        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "letmein!!"
        click_button "Log in"

        expect(page).to have_content "Your email/password combination was incorrect"
      end

      scenario "adds social networks to verify account, uses them to log in and unlinks them from the account" do
        setup_omniauth
        setup_valid_facebook_callback
        setup_valid_twitter_callback

        click_link "Dashboard"
        click_link "Edit profile"
        click_link "Connect with Facebook", match: :first

        expect(page).to have_content "Successfully verified your account with Facebook"

        click_link "Edit profile"
        click_link "View public profile", match: :first
        expect(page).to have_css "i[title='Verified with Facebook']"

        click_link "Dashboard"
        click_link "Edit profile"
        click_link "Connect with Twitter", match: :first

        expect(page).to have_content "Successfully verified your account with Twitter"

        click_link "Edit profile"
        click_link "View public profile", match: :first
        expect(page).to have_css "i[title='Verified with Facebook']"
        expect(page).to have_css "i[title='Verified with Twitter']"

        click_link "Log out"
        click_link "Log in"
        within(".user-sign-in") { click_link "Facebook" }

        expect(page).to have_content "Successfully authenticated from Facebook account"
        click_link "Dashboard"
        click_link "Edit profile"
        click_link "View public profile", match: :first
        expect(page).to have_css "i[title='Verified with Facebook']"
        expect(page).to have_css "i[title='Verified with Twitter']"

        click_link "Log out"
        click_link "Log in"
        within(".user-sign-in") { click_link "Twitter" }

        expect(page).to have_content "Successfully authenticated from Twitter account"
        click_link "Dashboard"
        click_link "Edit profile"
        click_link "View public profile", match: :first
        expect(page).to have_css "i[title='Verified with Facebook']"
        expect(page).to have_css "i[title='Verified with Twitter']"

        click_link "Dashboard"
        click_link "Edit profile"
        click_link "Disconnect from Facebook", match: :first
        expect(page).to have_content "Successfully disconnected Facebook from your account"
        click_link "Disconnect from Twitter", match: :first
        expect(page).to have_content "Successfully disconnected Twitter from your account"

        click_link "Log out"
        click_link "Sign up"

        within(".user-sign-up") { click_link "Facebook" }
        expect(page).to have_content "Please complete your profile"
        expect(page).to_not have_field "user_email", with: "user@example.com"
      end
    end
  end

  context "guests sign up using social network" do
    before(:each) { setup_omniauth }

    scenario "valid facebook authentication" do
      setup_valid_facebook_callback

      visit root_path
      click_link "Sign up"
      within(".user-sign-up") { click_link "Facebook" }

      expect(page).to have_content "Successfully authenticated from Facebook account"
      expect(page).to have_content "Please complete your profile"
      expect(page).to have_field "user_email", with: "user@example.com"
      expect(page).to have_field "user_first_name", with: "Cookie"
      expect(page).to have_field "user_last_name", with: "Monster"
      fill_in "user_first_name", with: "C."
      fill_in "user_date_of_birth", with: "1990-06-18"
      fill_in "user_profession", with: "Cookie monster"
      fill_in "user_greeting", with: "Cookies cookies cookies"
      fill_in "user_bio", with: "I like cookies"
      fill_in "user_mobile_number", with: "0123456789"
      fill_in "user_favorite_cuisine", with: "Chocolate"

      click_button "Save profile"
      expect(page).to have_content "Your profile has successfully been saved"
      expect(page).to have_content "C. Monster"
    end

    scenario "invalid facebook authentication" do
      setup_invalid_facebook_callback

      visit root_path
      click_link "Sign up"
      within(".user-sign-up") { click_link "Facebook" }

      expect(page).to have_content 'Could not authenticate you from Facebook because "Invalid credentials"'
      expect(current_path).to eq new_user_registration_path
    end

    scenario "valid twitter authentication" do
      setup_valid_twitter_callback

      visit root_path
      click_link "Sign up"
      within(".user-sign-up") { click_link "Twitter" }

      expect(page).to have_content "Successfully authenticated from Twitter account"
      expect(page).to have_content "Please complete your profile"
      fill_in "user_email", with: "user@example.com"
      fill_in "user_first_name", with: "Cookie"
      fill_in "user_last_name", with: "Monster"
      fill_in "user_date_of_birth", with: "1990-06-18"
      fill_in "user_profession", with: "Cookie monster"
      fill_in "user_greeting", with: "Cookies cookies cookies"
      fill_in "user_bio", with: "I like cookies"
      fill_in "user_mobile_number", with: "0123456789"
      fill_in "user_favorite_cuisine", with: "Chocolate"

      click_button "Save profile"
      expect(page).to have_content "Your profile has successfully been saved"
    end

    scenario "invalid twitter authentication" do
      setup_invalid_twitter_callback

      visit root_path
      click_link "Sign up"
      within(".user-sign-up") { click_link "Twitter" }

      expect(page).to have_content 'Could not authenticate you from Twitter because "Invalid credentials"'
      expect(current_path).to eq new_user_registration_path
    end

    scenario "user tries to associate an existing social network to another profile" do
      setup_valid_facebook_callback

      visit root_path
      click_link "Sign up"
      within(".user-sign-up") { click_link "Facebook" }

      fill_in "user_first_name", with: "C."
      fill_in "user_date_of_birth", with: "1990-06-18"
      fill_in "user_profession", with: "Cookie monster"
      fill_in "user_greeting", with: "Cookies cookies cookies"
      fill_in "user_bio", with: "I like cookies"
      fill_in "user_mobile_number", with: "0123456789"
      fill_in "user_favorite_cuisine", with: "Chocolate"

      click_button "Save profile"

      click_link "Log out"

      setup_valid_twitter_callback

      visit root_path
      click_link "Sign up"
      within(".user-sign-up") { click_link "Twitter" }

      expect(page).to have_content "Successfully authenticated from Twitter account"
      expect(page).to have_content "Please complete your profile"
      fill_in "user_email", with: "joe@bloggs.com"
      fill_in "user_first_name", with: "Joe"
      fill_in "user_last_name", with: "Bloggs"
      fill_in "user_date_of_birth", with: "1980-08-23"
      fill_in "user_profession", with: "Professional human"
      fill_in "user_bio", with: "Greetings"
      fill_in "user_mobile_number", with: "0123456789"
      fill_in "user_favorite_cuisine", with: "Food"

      click_button "Save profile"
      click_link "Edit profile"

      setup_valid_facebook_callback

      click_link "Connect with Facebook", match: :first
      expect(page).to have_content "Oops, we detected another account with the same Facebook authentication"
    end
  end
end
