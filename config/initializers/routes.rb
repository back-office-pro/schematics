# frozen_string_literal: true

Rails.configuration.exceptions_app = Rails.application.routes

Rails.application.routes.prepend do
  mount Schematics::Engine, at: '/'
  localized do
    get 'login', to: 'sessions#new', as: :login
    mount Tenant.backend.engine, at: '/admin/jobs', constraints: Schematics::AdminConstraint
    Tenant
      .schema
      .entities
      .map(&:router)
      .each(&method(:eval))
  end
end
