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
      expect(mail.body.encoded).to include "You are booked in to attend #{event.title}."
    end

    it "includes the event title" do
      expect(mail.body.encoded).to include "#{event.title}"
    end

    it "includes the event location" do
      expect(mail.body.encoded).to include "#{event.location}"
    end

    it "includes the event date" do
      expect(mail.body.encoded).to include "20th January 2015 7:45pm"
    end

    it "includes the order price" do
      expect(mail.body.encoded).to include "15.00"
    end
  end
end
