Rails.application.routes.draw do
  resources :categories
  resources :users
  resources :sub_categories
  resources :directories
  resources :products
  resources :clients
  resources :messages
  devise_for :users, path: 'u'
end
