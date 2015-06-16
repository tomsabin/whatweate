require "rails_helper"

describe Admin::HostsController do
  let(:user_z) { FactoryGirl.create(:user, first_name: "Zack") }
  let(:host) { FactoryGirl.create(:host, user: user_z) }
  before { sign_in FactoryGirl.create(:admin) }

  describe "#edit" do
    describe "@users" do
      let!(:user_a) { FactoryGirl.create(:user, first_name: "Albert") }
      let!(:user_b) { FactoryGirl.create(:user, first_name: "Borris") }

      it "correctly sets the order of users" do
        get :edit, id: host.id
        expect(assigns[:users]).to be_a Draper::CollectionDecorator
        expect(assigns[:users].to_ary).to eq [user_z, user_a, user_b]
      end
    end
  end
end
