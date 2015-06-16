require "rails_helper"

describe AdminMessengerJob do
  it "passes the arguments to AdminMessenger.broadcast" do
    expect(AdminMessenger).to receive(:broadcast).with("Message")
    AdminMessengerJob.perform_later("Message")
  end
end
