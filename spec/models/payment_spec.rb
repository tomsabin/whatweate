require "rails_helper"

describe Payment do
  it { should belong_to(:booking) }

  it "accepts a token as a virtual attribute" do
    payment = described_class.new(booking: Booking.new, token: "token")
    expect(payment.token).to eq("token")
  end
end
