Rails.application.routes.draw do
  devise_for :users

  resources :profile, only: [:new, :create]
  get 'profile', to: 'profile#show'

  root 'welcome#home'

  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_error'
end
