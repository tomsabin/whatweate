require 'rails_helper'

describe Profile do
  describe 'validations' do
    it { should belong_to(:user) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:date_of_birth) }
    it { should validate_presence_of(:profession) }
    it { should validate_presence_of(:bio) }
    it { should validate_presence_of(:mobile_number) }
    it { should validate_presence_of(:favorite_cuisine) }
    it { should_not validate_presence_of(:greeting) }
  end
end
