require "rails_helper"

describe EventsController do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:host) { FactoryGirl.create(:host) }
  let!(:event) { FactoryGirl.create(:event, host: host) }

  describe "#show" do
    context "event host has a user association" do
      let!(:host) { FactoryGirl.create(:host, user: user) }

      before { get :show, id: event.id }

      describe "@event_host" do
        it "should eq the event's host" do
          expect(assigns(:event_host)).to eq host
        end
      end

      describe "@event_user" do
        it "should eq the host's user account" do
          expect(assigns(:event_user)).to eq user
        end
      end

      describe "@guests" do
        it { expect(assigns(:guests)).to be_a Draper::CollectionDecorator }
        it { expect(assigns(:guests).to_ary).to be_empty }
      end

      describe "@already_booked" do
        it { expect(assigns(:already_booked)).to eq false }
      end

      describe "@current_user_is_event_host" do
        it { expect(assigns(:current_user_is_event_host)).to eq false }
      end
    end

    context "event host does not have a user association" do
      let!(:host) { FactoryGirl.create(:host) }

      before { get :show, id: event.id }

      describe "@event_host" do
        it "should eq the event's host" do
          expect(assigns(:event_host)).to eq host
        end
      end

      describe "@event_user" do
        it { expect(assigns(:event_user)).to eq nil }
      end

      describe "@guests" do
        it { expect(assigns(:guests)).to be_a Draper::CollectionDecorator }
        it { expect(assigns(:guests).to_ary).to be_empty }
      end

      describe "@already_booked" do
        it { expect(assigns(:already_booked)).to eq false }
      end

      describe "@current_user_is_event_host" do
        it { expect(assigns(:current_user_is_event_host)).to eq false }
      end
    end

    context "event with guests" do
      let(:guest) { FactoryGirl.create(:user) }

      before do
        Booking.create(event: event, user: guest)
        get :show, id: event.id
      end

      describe "@event_host" do
        it "should eq the event's host" do
          expect(assigns(:event_host)).to eq host
        end
      end

      describe "@event_user" do
        it { expect(assigns(:event_user)).to eq nil }
      end

      describe "@guests" do
        it { expect(assigns(:guests)).to be_a Draper::CollectionDecorator }
        it "should eq an array of the guests" do
          expect(assigns(:guests).to_ary).to eq [guest]
        end
      end

      describe "@already_booked" do
        it { expect(assigns(:already_booked)).to eq false }
      end

      describe "@current_user_is_event_host" do
        it { expect(assigns(:current_user_is_event_host)).to eq false }
      end
    end

    context "current user is already booked onto event" do
      before do
        Booking.create(event: event, user: user)
        sign_in user
        get :show, id: event.id
      end

      describe "@event_host" do
        it "should eq the event's host" do
          expect(assigns(:event_host)).to eq host
        end
      end

      describe "@event_user" do
        it { expect(assigns(:event_user)).to eq nil }
      end

      describe "@guests" do
        it { expect(assigns(:guests)).to be_a Draper::CollectionDecorator }
        it "should eq an array of the guests" do
          expect(assigns(:guests).to_ary).to eq [user]
        end
      end

      describe "@already_booked" do
        it { expect(assigns(:already_booked)).to eq true }
      end

      describe "@current_user_is_event_host" do
        it { expect(assigns(:current_user_is_event_host)).to eq false }
      end
    end

    context "current user is the event host" do
      let!(:host) { FactoryGirl.create(:host, user: user) }

      before do
        sign_in user
        get :show, id: event.id
      end

      describe "@event_host" do
        it "should eq the event's host" do
          expect(assigns(:event_host)).to eq host
        end
      end

      describe "@event_user" do
        it "should eq the host's user account" do
          expect(assigns(:event_user)).to eq user
        end
      end

      describe "@guests" do
        it { expect(assigns(:guests)).to be_a Draper::CollectionDecorator }
        it { expect(assigns(:guests).to_ary).to be_empty }
      end

      describe "@already_booked" do
        it { expect(assigns(:already_booked)).to eq false }
      end

      describe "@current_user_is_event_host" do
        it { expect(assigns(:current_user_is_event_host)).to eq true }
      end
    end
  end
end
