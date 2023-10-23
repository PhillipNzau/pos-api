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
      post '/register', to: 'users#register'
      post '/login', to: 'users#login'
      resources :users, only: [:index, :show, :destroy, :update]
      resources :products, only: [:create, :index, :show]
      resources :categories, only: [:create, :index, :show]
    end
  end
end
