require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.has_role? :admin } do
    mount Sidekiq::Web =>'/sidekiq'
  end

  root "products#index"

  get "up" => "rails/health#show", as: :rails_health_check

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
    collection { post :import }
  end
  resources :discounts
  resources :categories
  resources :category do
    resources :products, only: :index
  end
end
