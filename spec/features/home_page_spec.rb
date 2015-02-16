require 'rails_helper'

describe 'the home page' do
  before { visit root_path }

  context 'header' do
    it 'shows the expected content' do
      within 'header' do
        expect(page).to have_link 'How it works'
        expect(page).to have_link 'Become a host'
      end
    end
  end

  context 'proposition' do
    it 'shows the expected content' do
      within '.proposition' do
        expect(page).to have_link 'Join a table'
      end
    end
  end

  context 'newsletter' do
    it 'shows a MailChimp form' do
      within '.newsletter' do
        expect(page).to have_field 'FNAME'
        expect(page).to have_field 'LNAME'
        expect(page).to have_field 'EMAIL'
        expect(page).to have_button 'Let Me In!'
      end
    end
  end

  context 'events' do
    xit 'shows the expected content' do
      within '.events' do
      end
    end
  end

  context 'footer' do
    it 'matches the links in the header' do
      within 'footer' do
        expect(page).to have_link 'How it works'
        expect(page).to have_link 'Become a host'
      end
    end

    it 'shows links to legal pages' do
      within 'footer' do
        expect(page).to have_link 'Terms of use'
        expect(page).to have_link 'Privacy policy'
      end
    end

    it 'displays links to social media platforms' do
      within 'footer' do
        expect(page).to have_link 'Facebook'
        expect(page).to have_link 'Twitter'
        expect(page).to have_link 'Instagram'
        expect(page).to have_link 'Email'
      end
    end
  end
end
