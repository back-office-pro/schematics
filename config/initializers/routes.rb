# frozen_string_literal: true

Rails.configuration.exceptions_app = Rails.application.routes

Rails.application.routes.prepend do
  mount Schematics::Engine, at: '/'
  localized do
    Tenant.schema.load_routes
    get 'login', to: 'sessions#new', as: :login
    mount Schematics::Tenant.current.storage.engine,
          at: '/admin/jobs',
          constraints: Schematics::AdminConstraint
  end
end
