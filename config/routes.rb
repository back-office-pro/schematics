Schematics::Engine.routes.draw do
  default_url_options host: "localhost:3000"

  root 'dashboard#home'

  localized do
    get 'search',             to: 'dashboard#search',     as: :search
    get 'timeline',           to: 'dashboard#timeline',   as: :timeline
    get 'login',              to: 'sessions#new',         as: :login
    get 'profile',            to: 'sessions#edit',        as: :profile
    delete 'logout',          to: 'sessions#destroy',     as: :logout
    get 'password_lost',      to: 'password_resets#new',  as: :password_lost
    get 'password_lost/:id',  to: 'password_resets#edit'
    resource  :sessions, except: [:index, :show]
    resources :password_resets, only: [:new, :create, :edit, :update]
    resources :files, only: [:create, :update, :destroy]
  end
end
