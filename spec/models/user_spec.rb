require "rails_helper"

describe User do
  it { should have_many(:bookings).dependent(:destroy) }

  context "signed up" do
    subject { FactoryGirl.build(:user_without_profile) }

    describe "validations" do
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }
      it { should validate_presence_of(:email) }
      it { should_not validate_presence_of(:date_of_birth) }
      it { should_not validate_presence_of(:profession) }
      it { should_not validate_presence_of(:bio) }
      it { should_not validate_presence_of(:mobile_number) }
      it { should_not validate_presence_of(:favorite_cuisine) }
      it { should_not validate_presence_of(:greeting) }
    end
  end

  context "prompted to complete their profile" do
    subject { FactoryGirl.create(:user_with_profile) }

    describe "validations" do
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }
      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:date_of_birth) }
      it { should validate_presence_of(:profession) }
      it { should validate_presence_of(:bio) }
      it { should validate_presence_of(:mobile_number) }
      it { should validate_presence_of(:favorite_cuisine) }
      it { should_not validate_presence_of(:greeting) }
    end
  end
end
