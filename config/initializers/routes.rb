# frozen_string_literal: true

require 'sidekiq/web'

Rails.configuration.to_prepare do
  Rails.application.routes.default_url_options = Rails.application.config.action_mailer.default_url_options # rubocop:disable Layout/LineLength
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
end
