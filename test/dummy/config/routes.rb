Rails.application.routes.draw do
  resources :categories
  resources :sub_categories
  resources :directories
  resources :products
  resources :clients
end
