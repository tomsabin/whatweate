require "rails_helper"

describe EventNotifier do
  let(:event) { FactoryGirl.create(:event, seats: 1) }

  describe ".new_booking" do
    it "progresses the event to sold_out if the seat limit is reached" do
      expect(event.sold_out?).to eq false
      new_booking
      expect(event.sold_out?).to eq true
      expect{new_booking}.to_not raise_error { AASM::InvalidTransition }
      expect(Event.last.sold_out?).to eq true
    end
  end

  def new_booking
    notifier = described_class.new(event)
    Booking.create(event: event, user: FactoryGirl.create(:user))
    notifier.new_booking
  end
end
