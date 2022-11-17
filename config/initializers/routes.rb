# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.configuration.exceptions_app = Rails.application.routes

Rails.application.routes.prepend do
  mount Schematics::Engine, at: '/'
  mount Sidekiq::Web, at: '/sidekiq', constraints: Schematics::AdminConstraint
  localized do
    ::Tenant.current_schema.load_routes
    get 'login', to: 'sessions#new', as: :login
  end
end
