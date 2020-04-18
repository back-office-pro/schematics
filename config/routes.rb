Schematics::Engine.routes.draw do
  root 'dashboard#home'

  localized do
    get 'login',             to: 'sessions#new',         as: :login
    get 'profile',           to: 'sessions#edit',        as: :profile
    delete 'logout',         to: 'sessions#destroy',     as: :logout
    get 'password_lost',     to: 'password_resets#new',  as: :password_lost
    get 'password_lost/:id', to: 'password_resets#edit'
    resource  :timeline, only: :show
    resource  :sessions, except: :show
    resources :searches, only: [:create, :show], param: :query
    resources :password_resets, only: [:new, :create, :edit, :update]
    resources :files, only: [:create, :update, :destroy]
  end
end
