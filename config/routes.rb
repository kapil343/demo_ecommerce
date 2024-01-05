Rails.application.routes.draw do
   root "home#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :users do
    resources :products
    resources :addresses
    resource :cart
  end
  resource :cart
  resources :orders

  resources :products
  resources :categories

  resources :category do
    resources :products, only: :index
  end
  resources :discounts
end
