# frozen_string_literal: true

Rollbar.configure do |config|
  config.access_token = Schematics::Engine.credentials.rollbar[:api_key]
  config.enabled = !Rails.env.test?
  config.use_sidekiq
  config.environment = ENV['ROLLBAR_ENV'].presence || Rails.env
end
