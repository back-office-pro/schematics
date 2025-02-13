# frozen_string_literal: true

Rails.configuration.exceptions_app = Rails.application.routes

Rails.application.routes.append do
  direct(:website) { Server.url }
  mount Schematics::Engine, at: '/'
  mount MissionControl::Jobs::Engine, at: '/internal/jobs'
  localized do
    get 'auth/:provider/callback', to: 'sessions#create', as: :omniauth_login
    get 'up', to: 'rails/health#show', as: :health_check
    get 'service-worker', to: 'rails/pwa#service_worker', as: :pwa_service_worker
    get 'manifest', to: 'rails/pwa#manifest', as: :pwa_manifest
    get 'login', to: 'sessions#new', as: :login
    draw :resources
  end
end
