# frozen_string_literal: true

Sidekiq.configure_server do |config|
  opts = Schematics::Engine.config_for(:backend)
  config.merge!(opts)
  config.queues = opts[:queues]
  config.concurrency = opts[:concurrency]
  config.redis = {
    url: ENV.fetch('REDIS_URL', 'redis://localhost:6379'),
    network_timeout: 2,
    pool_timeout: 1
  }
end
