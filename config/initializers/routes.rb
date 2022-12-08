# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.configuration.exceptions_app = Rails.application.routes

Rails.application.routes.prepend do
  mount Sidekiq::Web, at: '/sidekiq'
  Schematics::Tenant.all.each do |tenant|
    namespace tenant.subdomain do
      localized do
        mount Schematics::Engine, at: '/'
        tenant.schema.load_routes
        get 'login', to: 'sessions#new', as: :login
      end
    end
  end
end
