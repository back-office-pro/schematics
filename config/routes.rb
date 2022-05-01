# frozen_string_literal: true

Schematics::Engine.routes.draw do
  root Schematics::Schema.instance.root_route

  localized do
    draw :dashboard
    draw :exceptions
    draw :swagger
    draw :password_resets
    resource :preferences, only: %i[edit update]
    resource :profile, only: %i[edit update], controller: :profile
    resource :schema, only: %i[edit update], controller: :schema
    resources :versions, only: %i[index show] do
      patch :revert, on: :member
    end
  end
end
