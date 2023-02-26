# frozen_string_literal: true

Sidekiq.configure_server do |config|
  opts = Schematics::Engine.config_for(:backend)
  config.merge!(opts)
  config.queues = opts[:queues]
  config.concurrency = opts[:concurrency]
end
