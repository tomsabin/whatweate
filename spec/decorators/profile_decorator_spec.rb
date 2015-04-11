require "rails_helper"

describe ProfileDecorator do
  describe "date_of_birth" do
    let(:profile) { Profile.new(date_of_birth: date).decorate }

    context "when present" do
      let(:date) { Date.new(1992, 01, 20) }
      it { expect(profile.date_of_birth).to eq("20th January 1992") }
    end

    context "when empty" do
      let(:date) { nil }
      it { expect(profile.date_of_birth).to be_blank }
    end
  end
end
