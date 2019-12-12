Schematics::Engine.routes.draw do
  root 'dashboard#home'
  get 'search',     to: 'dashboard#search',   as: :search
  get 'timeline',   to: 'dashboard#timeline', as: :timeline
  get 'login',      to: 'sessions#new',       as: :login
  delete 'logout',  to: 'sessions#destroy',   as: :logout
  resources :sessions, only: [:new, :create, :destroy]
  resources :files, except: [:index, :show]
end
