Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root 'products#home'
  resources :products
  resources :staff, only: [:index, :new, :create, :destroy]
end
