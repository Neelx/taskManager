Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root goes to dashboard (protected)
  root "dashboard#index"

  # Authentication
  get    "signup",  to: "registrations#new",     as: :signup
  post   "signup",  to: "registrations#create"
  get    "login",   to: "sessions#new",           as: :login
  post   "login",   to: "sessions#create"
  delete "logout",  to: "sessions#destroy",       as: :logout

  # Tasks CRUD + toggle
  resources :tasks do
    member do
      patch :toggle_complete
    end
  end
end
