Rails.application.routes.draw do
  devise_for :users
  resources :keyword_mappings
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/kamigo/eat', to: 'kamigo#eat'
  post '/kamigo/webhook', to: 'kamigo#webhook'
end
