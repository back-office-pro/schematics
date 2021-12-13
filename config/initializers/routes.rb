# frozen_string_literal: true

require 'sidekiq/web'

Rails.configuration.exceptions_app = Rails.application.routes
Rails.application.routes.default_url_options = Rails.configuration.action_mailer.default_url_options

Rails.application.routes.prepend do
  mount Schematics::Engine, at: '/'
  constraints Schematics::AuthConstraint do
    mount GrapeSwaggerRails::Engine, at: '/api'
    mount Sidekiq::Web, at: '/sidekiq'
  end
  localized do
    Schematics::Schema.instance.load_routes
  end
end
