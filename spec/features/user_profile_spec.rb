require 'rails_helper'

describe 'users and profiles' do
  scenario 'guest signs up from the homepage' do
    visit root_path
    click_link 'Sign up'
    click_button 'Sign up'

    expect(page).to have_content '4 errors prohibited this user from being saved'

    fill_in 'Email', with: 'user@example.com'
    fill_in 'First name', with: 'Cookie'
    fill_in 'Last name', with: 'Monster'
    fill_in 'Password', with: 'letmein!!'
    fill_in 'Password confirmation', with: 'letmein!!'
    click_button 'Sign up'

    expect(page).to have_content 'Please complete your profile'
  end

  scenario 'user that has not completed their profile signs in from the homepage' do
    FactoryGirl.create(:user_without_profile, email: 'user@example.com', password: 'letmein!!')

    visit root_path
    click_link 'Sign in'
    click_button 'Sign in'

    expect(page).to have_content 'Your email/password combination was incorrect'

    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'letmein!!'
    click_button 'Sign in'

    expect(page).to_not have_content 'Signed in successfully'
    expect(page).to have_content 'Please complete your profile'

    click_button 'Save profile'
    expect(page).to have_content 'Please fill in the required fields'
    expect(page).to have_content '5 errors prohibited this profile from being saved'
    # change to 'please review the following errors'

    fill_in 'profile_date_of_birth', with: '01/01/1990'
    expect(page).to have_field('profile_date_of_birth_visible', checked: false)
    fill_in 'profile_profession', with: 'Cookie monster'
    fill_in 'profile_greeting', with: 'Cookies cookies cookies'
    fill_in 'profile_bio', with: 'I like cookies'
    fill_in 'profile_mobile_number', with: '0123456789'
    expect(page).to have_field('profile_mobile_number_visible', checked: false)
    fill_in 'profile_favorite_cuisine', with: 'Chocolate'

    click_button 'Save profile'
    expect(page).to have_content 'Thanks! Your profile has successfully been saved'

    expect(page).to_not have_content 'Date of birth: 1990-01-01'
    expect(page).to have_content 'Profession: Cookie monster'
    expect(page).to have_content 'Greeting: Cookies cookies cookies'
    expect(page).to have_content 'Bio: I like cookies'
    expect(page).to_not have_content 'Mobile number: 0123456789'
    expect(page).to have_content 'Favourite cuisine: Chocolate'
  end

  context 'as a user that has completed their profile' do
    before { FactoryGirl.create(:user, email: 'user@example.com', password: 'letmein!!') }

    scenario 'receives login error messages' do
      visit root_path
      click_link 'Sign in'
      click_button 'Sign in'

      expect(page).to have_content 'Your email/password combination was incorrect'

      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'letmein!!'
      click_button 'Sign in'

      expect(page).to have_content 'Signed in successfully'
      expect(page).to_not have_content 'Please complete your profile'
    end

    context 'having successfully signed in' do
      before(:each) do
        visit root_path
        click_link 'Sign in'
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'letmein!!'
        click_button 'Sign in'
      end

      scenario 'updates their profile' do
        click_link 'Profile'
        click_link 'Edit profile'

        fill_in 'profile_date_of_birth', with: ''

        click_button 'Save profile'

        expect(page).to have_content '1 error prohibited this profile from being saved'

        fill_in 'profile_date_of_birth', with: '01/01/1990'
        check 'profile_date_of_birth_visible'
        fill_in 'profile_profession', with: 'Cookie monster'
        fill_in 'profile_bio', with: 'I like cookies'
        fill_in 'profile_greeting', with: 'Cookies cookies cookies'
        fill_in 'profile_mobile_number', with: '0123456789'
        check 'profile_mobile_number_visible'
        fill_in 'profile_favorite_cuisine', with: 'Chocolate'

        click_button 'Save profile'
        expect(page).to have_content 'Your profile has successfully been saved'
        expect(page).to have_content 'Date of birth: 1990-01-01'
        expect(page).to have_content 'Profession: Cookie monster'
        expect(page).to have_content 'Bio: I like cookies'
        expect(page).to have_content 'Greeting: Cookies cookies cookies'
        expect(page).to have_content 'Mobile number: 0123456789'
        expect(page).to have_content 'Favourite cuisine: Chocolate'
      end

      scenario 'user updates their password' do
        click_link 'Profile'
        click_link 'Edit profile'
        click_link 'Change your password'

        fill_in 'user_current_password', with: 'this-is-not-my-password'
        fill_in 'user_password', with: 'newpassword'
        fill_in 'user_password_confirmation', with: 'newpassword'
        click_button 'Update password'

        expect(page).to have_content 'Current password was incorrect'

        fill_in 'user_current_password', with: 'letmein!!'
        fill_in 'user_password', with: 'newpassword'
        fill_in 'user_password_confirmation', with: 'newpassword'
        click_button 'Update password'

        expect(page).to have_content 'Your password was successfully updated'

        click_link 'Sign out'
        click_link 'Sign in'

        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'letmein!!'
        click_button 'Sign in'

        expect(page).to have_content 'Your email/password combination was incorrect'

        fill_in 'Password', with: 'newpassword'
        click_button 'Sign in'

        expect(page).to have_content 'Signed in successfully'
      end

      scenario 'deletes their account' do
        click_link 'Profile'
        click_link 'Edit profile'
        click_link 'Delete your account'

        expect(page).to have_content 'Are you sure you want to delete your account?'
        click_button 'Yes, delete my account'

        expect(current_path).to eq root_path

        click_button 'Sign in'

        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'letmein!!'
        click_button 'Sign in'

        expect(page).to have_content 'Your email/password combination was incorrect'
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
