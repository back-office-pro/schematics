# frozen_string_literal: true

Schematics::Engine.routes.draw do
  root Tenant.schema.root_route
  draw :pwa

  localized do
    draw :dashboard
    draw :exceptions
    get 'sudo', to: 'sudos#new', as: :sudo
    resource :preferences, only: %i[edit update]
    resource :one_time_passwords, only: %i[new create destroy]
    resource :profile, only: %i[edit update], controller: :profile
    resources :password_resets, only: %i[new create edit update], param: :token
    resources :sudos, only: :create
    resources :versions, only: %i[index show] do
      patch :revert, on: :member
    end
    constraints -> { Configuration.blog_feature_flag } do
      resources :blog, only: %i[index show], controller: :blog, param: :slug, format: :html
      resource :sitemap, only: :show, format: :xml, controller: :sitemap
    end
  end
end
