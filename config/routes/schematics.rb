# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

root 'home#index'
get 'emojis.json', to: 'emojis#index', as: :emojis
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
