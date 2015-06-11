require "rails_helper"

describe EventNotifier do
  let(:event) { FactoryGirl.create(:event, seats: 1, title: "Event Title") }

  describe ".create_booking_successful" do
    it "progresses the event to sold_out if the seat limit is reached" do
      expect(event.sold_out?).to eq false
      booking = Booking.create(event: event, user: FactoryGirl.create(:user))
      subject.create_booking_successful(booking)
      expect(event.sold_out?).to eq true
    end
  end

  describe ".create_event_successful" do
    it "notifies the admin" do
      message = "New event by #{event.host.name} has been submitted for approval: http://www.example.com/admin/events/event-title"
      expect(AdminMessenger).to receive(:broadcast).with(message)
      subject.create_event_successful(event)
    end
  end
end
