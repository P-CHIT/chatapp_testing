Rails.application.routes.draw do
  devise_for :users
  get "home/index"
  resources :messages
  resources :rooms

  get "up" => "rails/health#show", as: :rails_health_check
  root "rooms#index"
end
