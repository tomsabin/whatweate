Rails.application.routes.draw do
  root 'welcome#home'

  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_error'
end
