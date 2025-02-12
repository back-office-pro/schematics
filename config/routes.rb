# frozen_string_literal: true

Schematics::Engine.routes.draw do
  root 'home#index'
  get 'robots.txt', to: 'robots#index', as: :robots
  get 'emojis.json', to: 'emojis#index', as: :emojis

  localized do
    draw :exceptions
    get 'sudo', to: 'sudos#new', as: :sudo
    get 'admin', to: 'admin#index', as: :admin
    delete 'logout', to: 'home#destroy', as: :logout
    resource :user_notifications, only: :update
    resource :preferences, only: %i[edit update]
    resource :one_time_passwords, only: %i[show edit new update create destroy]
    resource :profile, only: %i[edit update], controller: :profile
    resources :password_resets, only: %i[new create edit update], param: :token
    resources :tokens, only: :create
    resources :sudos, only: :create
    resources :versions, only: %i[index show] do
      patch :revert, on: :member
    end
    resources :messages, only: [], resource: 'messages' do
      resources :message_replies, only: %i[new create], path: :replies, as: :replies
    end
  end
end
