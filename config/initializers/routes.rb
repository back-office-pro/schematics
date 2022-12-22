# frozen_string_literal: true

require 'sidekiq-scheduler/web'
require 'sidekiq/web'

Rails.configuration.exceptions_app = Rails.application.routes

Rails.application.routes.prepend do
  mount Schematics::Engine, at: '/'
  localized do
    Tenant.schema.load_routes
    get 'login', to: 'sessions#new', as: :login
    mount Tenant.storage.engine,
          at: '/admin/jobs',
          constraints: Schematics::AdminConstraint
  end
end
