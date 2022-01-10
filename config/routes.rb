# frozen_string_literal: true

Schematics::Engine.routes.draw do
  draw :dashboard
  draw :exceptions
  draw :swagger

  root Schematics::Schema.instance.root_route

  localized do
    draw :sessions
    draw :password_resets
    resources :searches, only: %i[create show], param: :query
    resource :preferences, only: %i[edit update]
    resource :schema, only: %i[edit update show], controller: :schema
    resources :versions, only: %i[index show] do
      patch :revert, on: :member
    end
  end
end
