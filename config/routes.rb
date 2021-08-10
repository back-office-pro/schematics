# frozen_string_literal: true

Schematics::Engine.routes.draw do
  draw :dashboard
  get 'swagger/open_api.json', to: 'swagger#open_api', as: :swagger_open_api
  get '404', to: 'exception#not_found'
  get '500', to: 'exception#internal_server_error'

  root Schematics::Schema.instance.root_route

  localized do
    draw :sessions
    draw :password_resets
    resources :searches, only: %i[create show], param: :query
    resource :preferences, only: %i[edit update]
    resource :schema, only: %i[edit update show], controller: :schema
    resources :versions, only: %i[index show] do
      member do
        get :revert
      end
    end
  end
end
