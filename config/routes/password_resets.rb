# frozen_string_literal: true

get 'password_lost',     to: 'password_resets#new',  as: :password_lost
get 'password_lost/:id', to: 'password_resets#edit', as: :new_password

resources :password_resets, only: %i[new create edit update], param: :token
