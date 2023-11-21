Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root 'products#home'
  resources :products do
    collection do
      get 'search'
    end
  end
  resources :staff, only: [:index, :new, :create, :destroy]
  resources :categories
  post '/cart/add_to_cart/:product_id', to: 'cart#add_to_cart', as: 'add_to_cart'
  get '/cart', to: 'cart#show_cart', as: 'cart'
  delete '/cart/:id', to: 'cart#destroy', as: 'delete_cart_item'

  resources :orders, only: [:index, :create,:update] do
    member do
      get 'payment_form'
      post 'process_payment'
    end
  end
  
  get '/myorders', to: 'orders#show_orders', as: 'myorders'
end
