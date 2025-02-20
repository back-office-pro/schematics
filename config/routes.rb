# Copyright © 2025 Dev & Software. All rights reserved.
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
    get '/messages/:id/replies/new', to: 'message_replies#new', as: :new_message_reply
    post '/messages/:id/replies', to: 'message_replies#create', as: :message_replies
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
  end
end
