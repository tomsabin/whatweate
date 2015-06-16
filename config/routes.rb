Rails.application.routes.draw do
  devise_for :admins
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks", registrations: "registrations" }

  resource :user, except: [:new, :create, :destroy] do
    collection do
      get "delete"
      get "edit_password"
      patch "update_password"
      delete "disconnect", controller: "identities"
    end
  end

  resources :member, only: :show, controller: "members"

  resources :events, only: [:show, :new, :create] do
    resources :bookings, only: [:create]
  end

  namespace :admin do
    get "dashboard", to: "pages#dashboard"

    resources :events do
      member do
        get "preview"
        patch "approve"
      end
    end

    resources :hosts

    root "events#index"
  end

  root "pages#home"

  get "/404", to: "errors#not_found"
  get "/500", to: "errors#internal_error"
end
