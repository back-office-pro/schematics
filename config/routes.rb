Schematics::Engine.routes.draw do
  root 'dashboard#home'
  get 'search',     to: 'dashboard#search',   as: :search
  get 'timeline',   to: 'dashboard#timeline', as: :timeline
  get 'login',      to: 'sessions#new',       as: :login
  get 'profile',    to: 'sessions#edit',      as: :profile
  delete 'logout',  to: 'sessions#destroy',   as: :logout
  resource :sessions, only: [:new, :create, :update, :destroy]
  resources :files, except: [:index, :show]
end
