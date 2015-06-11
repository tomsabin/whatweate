require "rails_helper"

describe UserNotifier do
  let(:user) { FactoryGirl.create(:user, :host) }

  describe ".create_host_successful" do
    it "emails the user that they are now a host" do
      expect { subject.create_host_successful(user.host) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
