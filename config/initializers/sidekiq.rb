# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV.fetch('REDIS_URL', 'redis://localhost:6379'),
    namespace: Schematics::Engine.tenant
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV.fetch('REDIS_URL', 'redis://localhost:6379'),
    namespace: Schematics::Engine.tenant
  }
end
