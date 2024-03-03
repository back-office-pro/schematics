# frozen_string_literal: true

Rails.configuration.exceptions_app = Rails.application.routes

Rails.application.routes.prepend do
  direct(:website) { Tenant.url }
  mount Schematics::Engine, at: '/'
  mount GoodJob::Engine, at: '/backend'
  localized do
    get 'auth/:provider/callback', to: 'sessions#create', as: :omniauth_login
    get 'up', to: 'rails/health#show', as: :health_check
    get 'login', to: 'sessions#new', as: :login
    Tenant
      .schema
      .entities
      .map(&:router)
      .each(&method(:eval))
  end
end
