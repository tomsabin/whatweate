require "rails_helper"

describe User do
  it { should have_many(:bookings).dependent(:destroy) }
  it { should have_many(:booked_events).through(:bookings) }
  it { should have_one(:host).inverse_of(:user) }

  describe "validations" do
    context "signed up from devise" do
      subject { FactoryGirl.create(:user_without_profile) }

      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }
      it { should_not validate_presence_of(:date_of_birth) }
      it { should_not validate_presence_of(:profession) }
      it { should_not validate_presence_of(:bio) }
      it { should_not validate_presence_of(:mobile_number) }
      it { should_not validate_presence_of(:favorite_cuisine) }
      it { should_not validate_presence_of(:greeting) }
    end

    context "signed up from devise and completed profile" do
      subject { FactoryGirl.create(:user_with_profile) }

      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }
      it { should validate_presence_of(:date_of_birth) }
      it { should validate_presence_of(:profession) }
      it { should validate_presence_of(:bio) }
      it { should validate_presence_of(:mobile_number) }
      it { should validate_presence_of(:favorite_cuisine) }
      it { should_not validate_presence_of(:greeting) }
    end

    context "signed up from omniauth" do
      subject { FactoryGirl.create(:user_from_omniauth_without_profile) }

      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }
      it { should validate_presence_of(:date_of_birth) }
      it { should validate_presence_of(:profession) }
      it { should validate_presence_of(:bio) }
      it { should validate_presence_of(:mobile_number) }
      it { should validate_presence_of(:favorite_cuisine) }
      it { should_not validate_presence_of(:greeting) }
    end

    context "signed up from omniauth and completed profile" do
      subject { FactoryGirl.create(:user_from_omniauth_with_profile) }

      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }
      it { should validate_presence_of(:date_of_birth) }
      it { should validate_presence_of(:profession) }
      it { should validate_presence_of(:bio) }
      it { should validate_presence_of(:mobile_number) }
      it { should validate_presence_of(:favorite_cuisine) }
      it { should_not validate_presence_of(:greeting) }
    end
  end

  describe "states" do
    context "successfully signed up from devise" do
      it { expect(FactoryGirl.build(:user_without_profile).state).to eq "profile_incomplete" }
    end

    context "successfully signed up from devise and has full profile fields but hasn't yet transistioned" do
      it { expect(FactoryGirl.build(:user_with_profile_pending_transition).state).to eq "completed_devise" }
    end

    context "successfully signed up from devise and has completed profile" do
      it { expect(FactoryGirl.build(:user_with_profile).state).to eq "completed_profile" }
    end

    context "successfully signed up from omniauth (twitter)" do
      it { expect(FactoryGirl.build(:user_from_omniauth_without_profile, :twitter).state).to eq "completed_omniauth" }
    end

    context "successfully signed up from omniauth (facebook)" do
      it { expect(FactoryGirl.build(:user_from_omniauth_without_profile, :facebook).state).to eq "completed_omniauth" }
    end

    context "successfully signed up from omniauth and has completed their profile" do
      it { expect(FactoryGirl.build(:user_from_omniauth_with_profile).state).to eq "completed_profile" }
    end
  end

  describe "transitions" do
    describe "complete_devise" do
      context "signed up from devise" do
        subject { FactoryGirl.create(:user_without_profile) }
        it { expect { subject.complete_devise! }.to change { subject.state }.from("profile_incomplete").to("completed_devise") }
      end

      context "signed up from devise and completed profile" do
        subject { FactoryGirl.create(:user_with_profile_pending_transition) }
        it { expect { subject.complete_devise! }.to_not change { subject.state }.from("completed_devise") }
      end

      context "signed up from omniauth" do
        subject { FactoryGirl.create(:user_from_omniauth_without_profile) }
        it { expect { subject.complete_devise! }.to_not change { subject.state }.from("completed_omniauth") }
      end

      context "signed up from omniauth and completed profile" do
        subject { FactoryGirl.create(:user_from_omniauth_with_profile) }
        it { expect { subject.complete_devise! }.to_not change { subject.state }.from("completed_profile") }
      end
    end

    describe "complete_profile" do
      context "profile_incomplete" do
        subject { User.new }
        it { expect { subject.complete_profile! }.to_not change { subject.state }.from("profile_incomplete") }
      end

      context "signed up from devise" do
        subject { FactoryGirl.create(:user_without_profile) }
        it { expect { subject.complete_profile! }.to_not change { subject.state }.from("profile_incomplete") }
      end

      context "signed up from devise and completed profile" do
        subject { FactoryGirl.create(:user_with_profile_pending_transition) }
        it { expect { subject.complete_profile! }.to change { subject.state }.from("completed_devise").to("completed_profile") }
      end

      context "signed up from omniauth" do
        subject { FactoryGirl.create(:user_from_omniauth_without_profile) }
        it { expect { subject.complete_profile! }.to change { subject.state }.from("completed_omniauth").to("completed_profile") }
      end

      context "signed up from omniauth and completed profile" do
        subject { FactoryGirl.create(:user_from_omniauth_with_profile) }
        it { expect { subject.complete_profile! }.to_not change { subject.state }.from("completed_profile") }
      end
    end
  end

  describe "full_name" do
    let(:user) { FactoryGirl.build(:user, first_name: "Joe", last_name: "Bloggs").decorate }

    it "concatenates first name and last name" do
      expect(user.full_name).to eq("Joe Bloggs")
    end
  end
end
