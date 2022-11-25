# frozen_string_literal: true

Schematics::Engine.routes.draw do
  root ::Tenant.schema.root_route

  localized do
    draw :dashboard
    draw :exceptions
    resource :preferences, only: %i[edit update]
    resource :profile, only: %i[edit update], controller: :profile
    resources :password_resets, only: %i[new create edit update], param: :token
    resources :versions, only: %i[index show] do
      patch :revert, on: :member
    end
  end
end
