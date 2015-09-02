require "rails_helper"

describe EventDecorator do
  describe "formatted_date_time" do
    let(:event) { FactoryGirl.build(:event, date: DateTime.new(2015, 01, 20, 19, 45)).decorate }
    it { expect(event.formatted_date_time).to eq("20th January 2015 7:45pm") }
  end

  describe "formatted_date" do
    let(:event) { FactoryGirl.build(:event, date: DateTime.new(2015, 01, 20, 19, 45)).decorate }
    it { expect(event.formatted_date).to eq("20th January 2015") }
  end

  describe "formatted_time" do
    let(:event) { FactoryGirl.build(:event, date: DateTime.new(2015, 01, 20, 19, 45)).decorate }
    it { expect(event.formatted_time).to eq("7:45pm") }
  end
end
