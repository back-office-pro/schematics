# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

get 'auth/:provider/callback', to: 'sessions#create', as: :omniauth_login
get 'up', to: 'rails/health#show', as: :health_check
get 'service-worker', to: 'rails/pwa#service_worker', as: :pwa_service_worker
get 'manifest', to: 'rails/pwa#manifest', as: :pwa_manifest
get 'login', to: 'sessions#new', as: :login
