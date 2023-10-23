Rails.application.routes.draw do
  # resources :product_categories
  # resources :categories
  # resources :product_inventories
  # resources :products
  # resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      get 'orders/checkout'
      post '/register', to: 'users#register'
      post '/login', to: 'users#login'
      patch 'users/update', to: 'users#update'
      resources :users, only: [:index, :show, :destroy]
      resources :products, only: [:create, :index, :show, :update, :destroy] do
        collection do
          get 'filter_by_category'
          get 'filter_by_name'
        end
      end
      resources :categories, only: [:create, :index, :show]
      resources :orders, only: [:create] do
        collection do
          post 'checkout'
          get 'checkout_history'
        end
      end
    end
    

  end
end
