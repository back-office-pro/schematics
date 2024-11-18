# frozen_string_literal: true

Schematics::Engine.routes.draw do
  root Tenant.schema.root_route
  get 'robots.txt', to: 'robots#index', as: :robots
  get 'emojis.json', to: 'emojis#index', as: :emojis

  localized do
    draw :dashboard
    draw :exceptions
    get 'sudo', to: 'sudos#new', as: :sudo
    get 'admin', to: 'admin#index', as: :admin
    resource :preferences, only: %i[edit update]
    resource :one_time_passwords, only: %i[show edit new update create destroy]
    resource :profile, only: %i[edit update], controller: :profile
    resources :password_resets, only: %i[new create edit update], param: :token
    resources :sudos, only: :create
    resources :versions, only: %i[index show] do
      patch :revert, on: :member
    end
    resources :messages, only: [], model_name: 'Message' do
      resources :message_replies, only: %i[new create], path: :replies, as: :replies
    end
    constraints -> { Configuration.blog_feature_flag } do
      resources :blog, only: %i[index show], controller: :blog, param: :slug, format: :html
      resource :sitemap, only: :show, format: :xml, controller: :sitemap
    end
  end
end
