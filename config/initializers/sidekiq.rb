# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.merge!(Tenant.backend_config)
  config.queues = Tenant.backend_config[:queues]
  config.concurrency = Tenant.backend_config[:concurrency]
end
