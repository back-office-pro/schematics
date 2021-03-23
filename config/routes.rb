Schematics::Engine.routes.draw do
  root 'dashboard#home'
  get  'dashboard/chart/:id',   to: 'dashboard#chart',  as: :dashboard_chart
  get  'swagger/open_api.json', to: 'swagger#open_api', as: :swagger_open_api
  post 'dashboard/read_notifications'
  post 'dashboard/toggle_sidebar'
  post 'dashboard/toggle_theme'

  localized do
    get 'login',             to: 'sessions#new',         as: :login
    get 'profile',           to: 'sessions#edit',        as: :profile
    delete 'logout',         to: 'sessions#destroy',     as: :logout
    get 'password_lost',     to: 'password_resets#new',  as: :password_lost
    get 'password_lost/:id', to: 'password_resets#edit', as: :new_password
    resource  :sessions, except: :show
    resource  :timeline, only: :show, controller: :timeline
    resources :searches, only: %i[create show], param: :query
    resources :password_resets, only: %i[new create edit update]
  end
end
