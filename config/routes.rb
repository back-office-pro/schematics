Schematics::Engine.routes.draw do
  root 'dashboard#home'
  get 'chart/:id', to: 'dashboard#chart', as: :chart
  get 'open_api.json', to: 'dashboard#open_api', as: :open_api

  localized do
    get 'login',             to: 'sessions#new',         as: :login
    get 'profile',           to: 'sessions#edit',        as: :profile
    delete 'logout',         to: 'sessions#destroy',     as: :logout
    get 'password_lost',     to: 'password_resets#new',  as: :password_lost
    get 'password_lost/:id', to: 'password_resets#edit', as: :new_password
    resource  :sessions
    resource  :timeline, only: :show, controller: :timeline
    resources :searches, only: %i[create show], param: :query
    resources :password_resets, only: %i[new create edit update]
  end
end
