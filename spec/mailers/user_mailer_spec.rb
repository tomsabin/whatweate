require "rails_helper"

describe UserMailer do
  let(:user) { FactoryGirl.create(:user) }
  let(:mail) { described_class.new_host(user) }

  describe "new_host" do
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
end
