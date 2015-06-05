require "rails_helper"

describe UserDecorator do
  describe "date_of_birth" do
    let(:user) { FactoryGirl.build(:user, date_of_birth: date).decorate }

    context "when present" do
      let(:date) { Date.new(1992, 01, 20) }
      it { expect(user.date_of_birth).to eq("20th January 1992") }
    end

    context "when empty" do
      let(:date) { nil }
      it { expect(user.date_of_birth).to eq("") }
    end
  end

  describe "full_name" do
    let(:user) { FactoryGirl.build(:user, first_name: "Joe", last_name: "Bloggs").decorate }

    it "concatenates first name and last name" do
      expect(user.full_name).to eq("Joe Bloggs")
    end
  end
end
