require "rails_helper"

describe UserMailer do
  describe "new_host" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { described_class.new_host(user) }

    it "renders the subject" do
      expect(mail.subject).to eql "New host"
    end

    it "renders the receiver email" do
      expect(mail.to).to eql [user.email]
    end

    it "renders the sender email" do
      expect(mail.from).to eql ["no-reply@whatweate.co"]
    end

    it "assigns @name" do
      expect(mail.body.encoded).to include "Congratulations! You are a new host."
    end
  end

  describe "booking_receipt" do
    let(:user) { FactoryGirl.create(:user) }
    let(:event) { FactoryGirl.create(:event, date: DateTime.new(2015, 01, 20, 19, 45), price: "15.00") }
    let(:mail) { described_class.booking_receipt(user, event) }

    it "renders the subject" do
      expect(mail.subject).to eql "Your receipt for #{event.title}"
    end

    it "renders the receiver email" do
      expect(mail.to).to eql [user.email]
    end

    it "renders the sender email" do
      expect(mail.from).to eql ["no-reply@whatweate.co"]
    end

    it "includes the user's full name" do
      expect(mail.body.encoded).to include "Hi #{user.full_name}"
    end

    it "includes the event overview" do
      expect(mail.body.encoded).to include "You are booked in to attend #{event.title} at 20th January 2015 7:45pm."
    end

    it "includes the event details" do
      expect(mail.body.encoded).to include "#{event.title}\r\n#{event.location} (#{event.location_url})\r\n20th January 2015 7:45pm"
    end

    it "includes the order details" do
      expect(mail.body.encoded).to include "1 x seat (£15.00)"
      expect(mail.body.encoded).to include "TOTAL\r\n£15.00"
    end
  end
end
