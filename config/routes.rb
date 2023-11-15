Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root 'products#home'
  resources :products
  resources :staff, only: [:index, :new, :create, :destroy]
  post '/cart/add_to_cart/:product_id', to: 'cart#add_to_cart', as: 'add_to_cart'
  get '/cart', to: 'cart#show_cart', as: 'cart'
end
