# frozen_string_literal: true

Rails.application.configure do
  config.good_job.execution_mode = :async
  config.good_job.enable_cron = true
  config.good_job.queues = Tenant.storage_config[:queues].join(',')
  config.good_job.cron = Tenant.storage_config[:schedule].deep_symbolize_keys
end
