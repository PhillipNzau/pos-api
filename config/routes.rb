Rails.application.routes.draw do
  resources :product_categories
  resources :categories
  resources :product_inventories
  resources :products
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
