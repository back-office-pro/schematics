# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.merge!(Tenant.storage_config)
  config.queues = Tenant.storage_config[:queues]
  config.concurrency = Tenant.storage_config[:concurrency]
end
