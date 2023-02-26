# frozen_string_literal: true

Rails.application.configure do
  opts = Schematics::Engine.config_for(:backend)
  config.good_job.execution_mode = :async
  config.good_job.enable_cron = true
  config.good_job.queues = opts[:queues].join(',')
  config.good_job.cron = opts.dig(:scheduler, :schedule).deep_symbolize_keys
end
