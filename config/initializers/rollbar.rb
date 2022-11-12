# frozen_string_literal: true

require 'rollbar/delay/sidekiq'

Rollbar.configure do |config|
  config.access_token = Schematics::Engine.credentials.rollbar[:server_key]
  config.enabled = !Rails.env.test?
  config.use_sidekiq unless Rails.env.test?
  config.environment = Rails.env
  config.async_json_payload = true
  config.person_method = :current_user
  config.payload_options = { tenant: ::Tenant.name }
end
