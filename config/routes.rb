Rails.application.routes.draw do
  get 'reviews/index'
  get 'order_items/index'
  get 'cart_items/index'
  root "products#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  resources :users do
    resources :products
    resources :addresses
    resource :cart, only: [:show, :update, :destroy]
    resources :orders do
      collection do
        patch 'bulk_update'
      end
    end
  end
  get 'users/:user_id/orders/:id/cancel', to: 'orders#cancel', as: 'cancel_user_order'

  post 'payments/create', to: 'payments#create'

  # for outside user context
  resource :cart
  resources :cart_items
  resources :orders
  resources :products do
    resources :reviews
  end
  resources :discounts
  resources :categories
  resources :category do
    resources :products, only: :index
  end
end
