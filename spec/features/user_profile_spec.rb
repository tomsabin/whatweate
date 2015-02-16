require 'rails_helper'

describe 'users and profiles' do
  scenario 'guest signs up from the homepage' do
    visit root_path
    click_link 'Sign up'

    click_button 'Sign up'

    expect(page).to have_content 'Please provide an email address'
    expect(page).to have_content 'Please provide a password'

    fill_in 'email_address', with: 'foo@bar.com'
    fill_in 'first_name', with: 'Cookie'
    fill_in 'last_name', with: 'Monster'
    fill_in 'password', with: 'letmein!!'
    fill_in 'password_confirmation', with: 'letmein!!'
    click_button 'Sign up'

    expect(page).to have_content 'Signed up successfully'
  end

  context 'as a user that has not completed their profile' do
    before { FactoryGirl.create(:user_without_profile) }

    scenario 'guest signs in from the homepage' do
      visit root_path
      click_link 'Sign in'

      expect(page).to have_content 'Your email/password combination was incorrect'

      fill_in 'email_address', with: 'foo@bar.com'
      fill_in 'password', with: 'letmein!!'
      click_button 'Sign in'

      expect(page).to_not have_content 'Signed in successfully'
      expect(page).to have_content 'Please complete your profile'

      click_button 'Save profile'
      expect(page).to have_content 'Please fill in the required fields'

      fill_in 'date_of_birth', with: '01/01/1990'
      check 'hide_date_of_birth'
      fill_in 'profession', with: 'Cookie monster'
      fill_in 'bio', with: 'I like cookies'
      fill_in 'greeting', with: 'Cookies cookies cookies'
      fill_in 'mobile_number', with: '0123456789'
      check 'hide_mobile_number'
      fill_in 'favourite_cuisine', with: 'Chocolate'

      click_button 'Save profile'
      expect(page).to have_content 'Successfully saved profile'
      expect(page).to have_content 'Date of birth: 01/01/1990'
      expect(page).to have_content 'Profession: Cookie monster'
      expect(page).to have_content 'Bio: I like cookies'
      expect(page).to have_content 'Greeting: Cookies cookies cookies'
      expect(page).to have_content 'Mobile number: 0123456789'
      expect(page).to have_content 'Favourite cuisine: Chocolate'
    end
  end

  context 'as a user that has completed their profile' do
    before { FactoryGirl.create(:user) }

    scenario 'receives login error messages' do
      visit root_path
      click_link 'Sign in'

      expect(page).to have_content 'Your email/password combination was incorrect'

      fill_in 'email_address', with: 'foo@bar.com'
      fill_in 'password', with: 'letmein!!'
      click_button 'Sign in'

      expect(page).to have_content 'Signed in successfully'
      expect(current_path).to eq root_path
    end

    context 'having successfully signed in' do
      before(:all) do
        visit root_path
        click_link 'Sign in'
        fill_in 'email_address', with: 'foo@bar.com'
        fill_in 'password', with: 'letmein!!'
        click_button 'Sign in'
      end

      scenario 'updates their profile' do
        click_link 'Profile'
        click_link 'Edit profile'

        fill_in 'date_of_birth', with: '01/01/1990'
        check 'hide_date_of_birth'
        fill_in 'profession', with: 'Cookie monster'
        fill_in 'bio', with: 'I like cookies'
        fill_in 'greeting', with: 'Cookies cookies cookies'
        fill_in 'mobile_number', with: '0123456789'
        check 'hide_mobile_number'
        fill_in 'favourite_cuisine', with: 'Chocolate'

        click_button 'Save profile'
        expect(page).to have_content 'Successfully saved profile'
        expect(page).to_not have_content 'Date of birth: 01/01/1990'
        expect(page).to have_content 'Profession: Cookie monster'
        expect(page).to have_content 'Bio: I like cookies'
        expect(page).to have_content 'Greeting: Cookies cookies cookies'
        expect(page).to_not have_content 'Mobile number: 0123456789'
        expect(page).to have_content 'Favourite cuisine: Chocolate'

        click_link 'Edit profile'

        check 'hide_date_of_birth'
        check 'hide_mobile_number'

        click_button 'Save profile'
        expect(page).to have_content 'Date of birth: 01/01/1990'
        expect(page).to have_content 'Mobile number: 0123456789'
      end

      scenario 'deletes their account' do
        click_link 'Edit profile'
        click_link 'Delete my account'

        expect(page).to have_content 'Are you sure you want to delete your account?'
        click_button 'Yes, delete my account'

        expect(current_path).to eq root_path

        click_button 'Sign in'

        fill_in 'email_address', with: 'foo@bar.com'
        fill_in 'password', with: 'letmein!!'
        click_button 'Sign in'

        expect(page).to have_content 'Your email/password combination was incorrect'
      end

      scenario 'user updates their password' do
        click_link 'Profile'
        click_link 'Edit profile'
        click_link 'Change my password'

        fill_in 'current_password', with: 'letmein!!'
        fill_in 'new_password', with: 'newpassword'
        fill_in 'new_password_confirmation', with: 'newpassword'
        click_button 'Update password'

        click_link 'Sign out'
        click_link 'Sign in'

        fill_in 'email_address', with: 'foo@bar.com'
        fill_in 'password', with: 'letmein!!'
        click_button 'Sign in'

        expect(page).to have_content 'Your email/password combination was incorrect'

        fill_in 'password', with: 'newpassword'
        click_button 'Sign in'

        expect(page).to have_content 'Signed in successfully'
      end

      xscenario 'uploads a profile picture' do
      end

      xscenario 'chooses an avatar' do
      end

      xscenario 'adds social networks to verify my account' do
        click_link 'Profile'
        click_link 'Verify your account'
        click_link 'Facebook'

        # facebook setup

        expect(page).to have_content 'Successfully verified your account with Facebook'
        expect(page).to have_content 'Verified'
        expect(page).to have_content 'Verified with Facebook'

        click_link 'Verify your account'
        click_link 'Twitter'

        # twitter setup

        expect(page).to have_content 'Successfully verified your account with Twitter'
        expect(page).to have_content 'Verified'
        expect(page).to have_content 'Verified with Facebook'
        expect(page).to have_content 'Verified with Twitter'
      end
    end
  end

  context 'guests sign up using a social network' do
    xscenario 'chooses facebook' do
      visit root_path
      click_link 'Sign up'
      click_link 'Sign up with your Facebook account'

      # facebook setup

      expect(page).to have_content 'Please complete your profile'

      # what can we get from facebook to populate the profile?
    end

    xscenario 'chooses twitter' do
      visit root_path
      click_link 'Sign up'
      click_link 'Sign up with your Facebook account'

      # twitter setup

      expect(page).to have_content 'Please complete your profile'

      # what can we get from twitter to populate the profile?
    end

    # some scenario to try and get conflicts :(
  end
end
