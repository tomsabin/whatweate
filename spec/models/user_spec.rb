require 'rails_helper'

describe User do
  describe 'validations' do
    it { should have_one(:profile) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
  end
end
