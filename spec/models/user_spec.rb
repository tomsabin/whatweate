require 'rails_helper'

describe User do
  describe 'validations' do
    it { should have_one(:profile).dependent(:destroy) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
  end
end
