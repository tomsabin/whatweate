Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  resource :profile, except: [:destroy]

  resource :user, only: [] do
    collection do
      get "delete"
      get "edit_password"
      patch "update_password"
    end
  end

  resource :identity, only: :destroy

  root "welcome#home"

  get "/404", to: "errors#not_found"
  get "/500", to: "errors#internal_error"
end
