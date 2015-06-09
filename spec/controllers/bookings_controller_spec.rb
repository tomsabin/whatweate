require "rails_helper"
include StripeHelpers

describe BookingsController do
  let!(:event) { FactoryGirl.create(:event, title: "Event title") }
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "#create" do
    it "redirects with the correct message when using valid card token" do
      VCR.use_cassette("stripe/valid_card") do
        post :create, event_id: "event-title", stripeToken: StripeHelpers.valid_card_token
      end
      expect(flash[:notice]).to eq "Thanks! We've booked you a seat."
      expect(response).to redirect_to(event_url(event))
    end

    it "redirects with the correct message when using an invalid card token" do
      VCR.use_cassette("stripe/card_error") do
        post :create, event_id: "event-title", stripeToken: StripeHelpers.card_error_token
      end
      expect(flash[:notice]).to eq "Your card was declined."
      expect(response).to redirect_to(event_url(event))
    end
  end
end
