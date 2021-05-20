Schematics::Engine.routes.draw do
  draw :dashboard
  get 'swagger/open_api.json', to: 'swagger#open_api', as: :swagger_open_api

  localized do
    draw :sessions
    draw :password_resets
    draw :versions
    resources :searches, only: %i[create show], param: :query
  end
end
