# frozen_string_literal: true

Rollbar.configure do |config|
  config.access_token = Schematics::Engine.credentials.rollbar[:server_key]
  config.enabled = !Rails.env.test?
  config.use_active_job(queue: 'rollbar')
  config.environment = Rails.env
  config.async_json_payload = true
  config.anonymize_user_ip = true
  config.person_method = :current_user
end
