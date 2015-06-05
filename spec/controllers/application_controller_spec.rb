require "rails_helper"

describe ApplicationController do
  describe "after_sign_in_path_for" do
    controller do
      def after_sign_in_path_for(resource)
        super(resource)
      end
    end

    before { sign_in resource }

    context "user has completed profile" do
      let(:resource) { FactoryGirl.create(:user_with_profile) }

      it "redirects to root" do
        expect(controller.after_sign_in_path_for(resource)).to eq root_path
      end
    end

    context "user has not completed profile" do
      let(:resource) { FactoryGirl.create(:user_without_profile) }

      it "redirects to root" do
        expect(controller.after_sign_in_path_for(resource)).to eq new_profile_path
      end
    end

    context "user signed up from omniauth has not completed profile" do
      let(:resource) { FactoryGirl.create(:user_from_omniauth_without_profile) }

      it "redirects to root" do
        expect(controller.after_sign_in_path_for(resource)).to eq new_profile_path
      end
    end

    context "admin signs in" do
      let(:resource) { FactoryGirl.create(:admin) }

      it "redirects to root" do
        expect(controller.after_sign_in_path_for(resource)).to eq admin_root_path
      end
    end
  end

  describe "store_location" do
    controller do
      def test
        render nothing: true
      end
    end

    before do
      routes.draw do
        get "test",  to: "anonymous#test"
        post "test", to: "anonymous#test"
      end
    end

    it "saves the last location when GET outside admin/user namespace" do
      expect { get :test }.to change { session[:user_return_to] }.from(nil).to("/test")
    end

    it "does not saves the last location when not GET" do
      expect { post :test }.to_not change { session[:user_return_to] }.from(nil)
    end
  end

end

class Admin::AnonymousController < ApplicationController; end

describe Admin::AnonymousController do
  describe "store_location" do
    controller do
      after_action :store_location

      def test
        render nothing: true
      end

      def store_location
        super
      end
    end

    it "does not save the last location when under admin namespace" do
      routes.draw do
        namespace :admin do
          get "test", to: "anonymous#test"
        end
      end
      expect { get :test }.to_not change { session[:user_return_to] }.from(nil)
    end
  end
end

class Users
  class AnonymousController < ApplicationController; end
end

describe Users::AnonymousController do
  describe "store_location" do
    controller do
      after_action :store_location

      def test
        render nothing: true
      end

      def store_location
        super
      end
    end

    it "does not save the last location when under admin namespace" do
      routes.draw do
        namespace :users do
          get "test", to: "anonymous#test"
        end
      end
      expect { get :test }.to_not change { session[:user_return_to] }.from(nil)
    end
  end
end
