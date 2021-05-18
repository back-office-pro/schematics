Schematics::Engine.routes.draw do
  draw :dashboard
  get 'swagger/open_api.json', to: 'swagger#open_api', as: :swagger_open_api

  localized do
    draw :sessions
    draw :password_resets
    resources :searches, only: %i[create show], param: :query
    resources :versions, only: %i[index show] do
      member do
        get :revert
        get :preferences
      end
    end
  end
end
