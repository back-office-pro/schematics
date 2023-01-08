# frozen_string_literal: true

Rails.configuration.exceptions_app = Rails.application.routes

Rails.application.routes.prepend do
  mount Schematics::Engine, at: '/'
  mount Tenant.backend.engine, at: '/backend'
  localized do
    get 'login', to: 'sessions#new', as: :login
    Tenant
      .schema
      .entities
      .map(&:router)
      .each(&method(:eval))
  end
end
