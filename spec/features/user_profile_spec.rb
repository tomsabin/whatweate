require "rails_helper"
include OmniAuthHelpers

describe "users and profiles" do
  scenario "guest signs up from the homepage" do
    visit root_path
    click_link "Sign up"
    click_button "Sign up"

    expect(page).to have_content "Please review the following errors"

    fill_in "Email", with: "user@example.com"
    fill_in "First name", with: "Cookie"
    fill_in "Last name", with: "Monster"
    fill_in "Password", with: "letmein!!"
    fill_in "Password confirmation", with: "letmein!!"
    click_button "Sign up"

    expect(page).to have_content "Please complete your profile"
  end

  scenario "user that has not completed their profile signs in from the homepage" do
    FactoryGirl.create(:user_without_profile,
                       first_name: "Cookie",
                       last_name: "Monster",
                       email: "user@example.com",
                       password: "letmein!!")

    visit root_path
    click_link "Sign in"
    click_button "Sign in"

    expect(page).to have_content "Your email/password combination was incorrect"

    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "letmein!!"
    click_button "Sign in"

    expect(page).to_not have_content "Signed in successfully"
    expect(page).to_not have_field "profile_user_email"
    expect(page).to have_field "profile_user_first_name", with: "Cookie"
    expect(page).to have_field "profile_user_last_name", with: "Monster"
    expect(page).to have_content "Please complete your profile"

    click_button "Save profile"
    expect(page).to have_content "Please review the following errors"

    fill_in "profile_date_of_birth", with: "01/01/1990"
    expect(page).to have_field("profile_date_of_birth_visible", checked: false)
    fill_in "profile_profession", with: "Cookie monster"
    fill_in "profile_greeting", with: "Cookies cookies cookies"
    fill_in "profile_bio", with: "I like cookies"
    fill_in "profile_mobile_number", with: "0123456789"
    expect(page).to have_field("profile_mobile_number_visible", checked: false)
    fill_in "profile_favorite_cuisine", with: "Chocolate"

    click_button "Save profile"
    expect(page).to have_content "Thanks! Your profile has successfully been saved"

    expect(page).to have_content "Email: user@example.com"
    expect(page).to have_content "First name: Cookie"
    expect(page).to have_content "Last name: Monster"
    expect(page).to_not have_content "Date of birth: 1990-01-01"
    expect(page).to have_content "Profession: Cookie monster"
    expect(page).to have_content "Greeting: Cookies cookies cookies"
    expect(page).to have_content "Bio: I like cookies"
    expect(page).to_not have_content "Mobile number: 0123456789"
    expect(page).to have_content "Favourite cuisine: Chocolate"
  end

  context "as a user that has completed their profile" do
    before { FactoryGirl.create(:user, email: "user@example.com", password: "letmein!!") }

    scenario "forgets their password" do
      visit root_path
      click_link "Sign in"
      click_button "Sign in"

      expect(page).to have_content "Your email/password combination was incorrect"

      click_link "Forgot your password?"

      fill_in "user_email", with: "user@example.com"
      click_button "Send me password reset instructions"

      expect(ActionMailer::Base.deliveries.first.subject).to eq "Reset password instructions"
      visit edit_user_password_path(reset_password_token)

      fill_in "user_password", with: "newpassword"
      fill_in "user_password_confirmation", with: "newpassword"
      click_button "Change my password"

      expect(page).to have_content "Your password has been changed successfully. You are now signed in."

      click_link "Sign out"
      click_link "Sign in"

      fill_in "user_email", with: "user@example.com"
      fill_in "user_password", with: "newpassword"
      click_button "Sign in"

      expect(page).to have_content "Signed in successfully"
      expect(page).to_not have_content "Please complete your profile"
    end

    def reset_password_token
      { reset_password_token: ActionMailer::Base.deliveries.first.body.raw_source.match(/reset_password_token=(.*)\"/)[1] }
    end

    context "having successfully signed in" do
      before(:each) do
        visit root_path
        click_link "Sign in"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "letmein!!"
        click_button "Sign in"
      end

      scenario "updates their profile" do
        click_link "Profile"
        click_link "Edit profile"

        fill_in "profile_user_email", with: "invalid"
        fill_in "profile_date_of_birth", with: ""

        click_button "Save profile"

        expect(page).to have_content "Please review the following errors"
        within(".profile_user_email") { expect(page).to have_content "is invalid" }
        within(".profile_date_of_birth") { expect(page).to have_content "can't be blank" }

        fill_in "profile_user_email", with: "me@cookie.com"
        fill_in "profile_user_first_name", with: "Cookie"
        fill_in "profile_user_last_name", with: "Monster"
        fill_in "profile_date_of_birth", with: "01/01/1990"
        check "profile_date_of_birth_visible"
        fill_in "profile_profession", with: "Cookie monster"
        fill_in "profile_bio", with: "I like cookies"
        fill_in "profile_greeting", with: "Cookies cookies cookies"
        fill_in "profile_mobile_number", with: "0123456789"
        check "profile_mobile_number_visible"
        fill_in "profile_favorite_cuisine", with: "Chocolate"

        click_button "Save profile"
        expect(page).to have_content "Your profile has successfully been saved"
        expect(page).to have_content "Email: me@cookie.com"
        expect(page).to have_content "First name: Cookie"
        expect(page).to have_content "Last name: Monster"
        expect(page).to have_content "Date of birth: 1990-01-01"
        expect(page).to have_content "Profession: Cookie monster"
        expect(page).to have_content "Bio: I like cookies"
        expect(page).to have_content "Greeting: Cookies cookies cookies"
        expect(page).to have_content "Mobile number: 0123456789"
        expect(page).to have_content "Favourite cuisine: Chocolate"
      end

      scenario "user updates their password" do
        click_link "Profile"
        click_link "Edit profile"
        click_link "Change your password"

        fill_in "user_current_password", with: "this-is-not-my-password"
        fill_in "user_password", with: "newpassword"
        fill_in "user_password_confirmation", with: "newpassword"
        click_button "Update password"

        within(".user_current_password") { expect(page).to have_content "was incorrect" }

        fill_in "user_current_password", with: "letmein!!"
        fill_in "user_password", with: "newpassword"
        fill_in "user_password_confirmation", with: "newpassword"
        click_button "Update password"

        expect(page).to have_content "Your password was successfully updated"

        click_link "Sign out"
        click_link "Sign in"

        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "letmein!!"
        click_button "Sign in"

        expect(page).to have_content "Your email/password combination was incorrect"

        fill_in "Password", with: "newpassword"
        click_button "Sign in"

        expect(page).to have_content "Signed in successfully"
      end

      scenario "deletes their account" do
        click_link "Profile"
        click_link "Edit profile"
        click_link "Delete your account"

        expect(page).to have_content "Are you sure you want to delete your account?"
        expect(page).to have_link "No, cancel"
        click_link "Yes, delete my account"

        expect(current_path).to eq root_path

        expect(page).to have_content "Your account has been successfully been deleted. We hope to see you again soon"

        click_link "Sign in"

        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "letmein!!"
        click_button "Sign in"

        expect(page).to have_content "Your email/password combination was incorrect"
      end

      scenario "adds social networks to verify account and uses them to sign in" do
        setup_omniauth
        setup_valid_facebook_callback
        setup_valid_twitter_callback

        click_link "Profile"
        click_link "Verify your account with Facebook"

        expect(page).to have_content "Successfully verified your account with Facebook"
        expect(page).to have_content "Verified with Facebook"

        click_link "Verify your account with Twitter"

        expect(page).to have_content "Successfully verified your account with Twitter"
        expect(page).to have_content "Verified with Facebook"
        expect(page).to have_content "Verified with Twitter"

        click_link "Sign out"
        click_link "Sign in"
        within(".social-networks") { click_link "Facebook" }

        expect(page).to have_content "Successfully authenticated from Facebook account"
        click_link "Profile"
        expect(page).to have_content "Verified with Facebook"
        expect(page).to have_content "Verified with Twitter"

        click_link "Sign out"
        click_link "Sign in"
        within(".social-networks") { click_link "Twitter" }

        expect(page).to have_content "Successfully authenticated from Twitter account"
        click_link "Profile"
        expect(page).to have_content "Verified with Facebook"
        expect(page).to have_content "Verified with Twitter"
      end
    end
  end

  context "guests sign up using a social network" do
    before(:each) { setup_omniauth }

    scenario "valid facebook authentication" do
      setup_valid_facebook_callback

      visit root_path
      click_link "Sign up"
      within(".social-networks") { click_link "Facebook" }

      expect(page).to have_content "Successfully authenticated from Facebook account"
      expect(page).to have_content "Please complete your profile"
      expect(page).to_not have_field "profile_user_email"
      expect(page).to have_field "profile_user_first_name", with: "Cookie"
      expect(page).to have_field "profile_user_last_name", with: "Monster"
      fill_in "profile_date_of_birth", with: "01/01/1990"
      fill_in "profile_profession", with: "Cookie monster"
      fill_in "profile_greeting", with: "Cookies cookies cookies"
      fill_in "profile_bio", with: "I like cookies"
      fill_in "profile_mobile_number", with: "0123456789"
      fill_in "profile_favorite_cuisine", with: "Chocolate"

      click_button "Save profile"
      expect(page).to have_content "Thanks! Your profile has successfully been saved"
    end

    scenario "invalid facebook authentication" do
      setup_invalid_facebook_callback

      visit root_path
      click_link "Sign up"
      within(".social-networks") { click_link "Facebook" }

      expect(page).to have_content 'Could not authenticate you from Facebook because "Invalid credentials"'
      expect(current_path).to eq new_user_registration_path
    end

    scenario "valid twitter authentication" do
      setup_valid_twitter_callback

      visit root_path
      click_link "Sign up"
      within(".social-networks") { click_link "Twitter" }

      expect(page).to have_content "Successfully authenticated from Twitter account"
      expect(page).to have_content "Please complete your profile"
      expect(page).to_not have_field "profile_user_email"
      fill_in "profile_user_first_name", with: "Cookie"
      fill_in "profile_user_last_name", with: "Monster"
      fill_in "profile_date_of_birth", with: "01/01/1990"
      fill_in "profile_profession", with: "Cookie monster"
      fill_in "profile_greeting", with: "Cookies cookies cookies"
      expect(page).to have_field 'profile_bio', with: 'I like cookies'
      fill_in "profile_mobile_number", with: "0123456789"
      fill_in "profile_favorite_cuisine", with: "Chocolate"

      click_button "Save profile"
      expect(page).to have_content "Thanks! Your profile has successfully been saved"
    end

    scenario "invalid twitter authentication" do
      setup_invalid_twitter_callback

      visit root_path
      click_link "Sign up"
      within(".social-networks") { click_link "Twitter" }

      expect(page).to have_content 'Could not authenticate you from Twitter because "Invalid credentials"'
      expect(current_path).to eq new_user_registration_path
    end
  end
end
