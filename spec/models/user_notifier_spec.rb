require "rails_helper"

describe UserNotifier do
  let(:user) { FactoryGirl.create(:user) }
  let(:subject) { described_class.new(user) }

  describe ".new_host" do
    it "emails the user that they are now a host" do
      expect { subject.new_host }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
