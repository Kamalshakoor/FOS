Rails.application.routes.draw do
  get 'dashboard/home'
  devise_for :users, controllers: { registrations: 'registrations' }
  root 'products#home'
  resources :products
  resources :staff, only: [:index, :new, :create, :destroy]
  resources :categories
  post '/cart/add_to_cart/:product_id', to: 'cart#add_to_cart', as: 'add_to_cart'
  get '/cart', to: 'cart#show_cart', as: 'cart'
  delete '/cart/:id', to: 'cart#destroy', as: 'delete_cart_item'
end
