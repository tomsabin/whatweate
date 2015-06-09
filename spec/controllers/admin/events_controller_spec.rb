require "rails_helper"

describe Admin::EventsController do
  let!(:event) { FactoryGirl.create(:event, :pending, title: "Event title") }
  before { sign_in FactoryGirl.create(:admin) }

  describe "#approve" do
    it "redirects back to the show page" do
      patch :approve, id: "event-title"
      expect(response).to redirect_to(admin_event_url(event))
    end

    it "sets the correct message when the event can be approved" do
      patch :approve, id: "event-title"
      expect(flash[:notice]).to eq "Event successfully approved"
    end

    context "event that is already approved" do
      let!(:event) { FactoryGirl.create(:event, title: "Event title") }

      it "redirects back to the show page with the correct message" do
        patch :approve, id: "event-title"
        expect(flash[:alert]).to eq "Event could not be approved"
      end
    end
  end
end
