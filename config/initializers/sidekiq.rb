# frozen_string_literal: true

Sidekiq.strict_args!(false) # TODO: rm when https://github.com/hotwired/turbo-rails/issues/535 fixed
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
