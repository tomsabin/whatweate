require "rails_helper"

describe MembersController do
  describe "#show" do
    before { get :show, id: user.id }

    context "member has not completed profile" do
      let(:user) { FactoryGirl.create(:user_without_profile) }

      it "redirects to the not found page" do
        expect(response).to redirect_to "/404"
      end
    end

    context "member is verified with social networks" do
      let(:user) { FactoryGirl.create(:user, :facebook, :twitter) }

      describe "@verified_with_facebook" do
        it { expect(assigns(:verified_with_facebook)).to eq true }
      end

      describe "@verified_with_twitter" do
        it { expect(assigns(:verified_with_twitter)).to eq true }
      end

      describe "@upcoming_booked_events" do
        it { expect(assigns(:upcoming_booked_events)).to eq [] }
      end

      describe "@past_booked_events" do
        it { expect(assigns(:past_booked_events)).to eq [] }
      end

      describe "@user_is_host" do
        it { expect(assigns(:user_is_host)).to eq false }
      end

      describe "@upcoming_hosted_events" do
        it { expect(assigns(:upcoming_hosted_events)).to eq nil }
      end

      describe "@past_hosted_events" do
        it { expect(assigns(:past_hosted_events)).to eq nil }
      end
    end

    context "member has booked (upcoming and past) events" do
      let(:user) { FactoryGirl.create(:user) }
      let(:upcoming_event) { FactoryGirl.create(:event) }
      let(:past_event) { FactoryGirl.create(:event, date: 1.day.ago) }

      before do
        Booking.create(event: upcoming_event, user: user)
        Booking.create(event: past_event, user: user)
        get :show, id: user.id
      end

      describe "@verified_with_facebook" do
        it { expect(assigns(:verified_with_facebook)).to eq false }
      end

      describe "@verified_with_twitter" do
        it { expect(assigns(:verified_with_twitter)).to eq false }
      end

      describe "@upcoming_booked_events" do
        it "should eq array of upcoming booked events" do
          expect(assigns(:upcoming_booked_events)).to eq [upcoming_event]
        end
      end

      describe "@past_booked_events" do
        it "should eq array of past booked events" do
          expect(assigns(:past_booked_events)).to eq [past_event]
        end
      end

      describe "@user_is_host" do
        it { expect(assigns(:user_is_host)).to eq false }
      end

      describe "@upcoming_hosted_events" do
        it { expect(assigns(:upcoming_hosted_events)).to eq nil }
      end

      describe "@past_hosted_events" do
        it { expect(assigns(:past_hosted_events)).to eq nil }
      end
    end

    context "member is a host and has hosted events (upcoming and past)" do
      let(:user) { FactoryGirl.create(:user) }
      let(:host) { FactoryGirl.create(:host, user: user )}
      let!(:upcoming_event) { FactoryGirl.create(:event, host: host) }
      let!(:past_event) { FactoryGirl.create(:event, date: 1.day.ago, host: host) }

      before do
        get :show, id: user.id
      end

      describe "@verified_with_facebook" do
        it { expect(assigns(:verified_with_facebook)).to eq false }
      end

      describe "@verified_with_twitter" do
        it { expect(assigns(:verified_with_twitter)).to eq false }
      end

      describe "@upcoming_booked_events" do
        it { expect(assigns(:upcoming_booked_events)).to eq [] }
      end

      describe "@past_booked_events" do
        it { expect(assigns(:past_booked_events)).to eq [] }
      end

      describe "@user_is_host" do
        it { expect(assigns(:user_is_host)).to eq true }
      end

      describe "@upcoming_hosted_events" do
        it "should eq array of upcoming hosted events" do
          expect(assigns(:upcoming_hosted_events)).to eq [upcoming_event]
        end
      end

      describe "@past_hosted_events" do
        it "should eq array of past hosted events" do
          expect(assigns(:past_hosted_events)).to eq [past_event]
        end
      end
    end
  end
end
