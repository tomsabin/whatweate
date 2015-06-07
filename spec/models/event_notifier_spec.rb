require "rails_helper"

describe EventNotifier do
  let(:event) { FactoryGirl.create(:event, seats: 1) }

  describe ".new_booking" do
    it "progresses the event to sold_out if the seat limit is reached" do
      expect(event.sold_out?).to eq false
      Booking.create(event: event, user: FactoryGirl.create(:user))
      subject.new_booking(event)
      expect(event.sold_out?).to eq true
    end
  end

  describe ".create_event_successful" do
    it "notifies the admin" do
      message = "New event by #{event.host.name} has been submitted for approval"
      expect(AdminMessenger).to receive(:broadcast).with(message)
      subject.new_event(event)
    end
  end
end
