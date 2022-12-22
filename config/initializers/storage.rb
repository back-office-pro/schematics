# frozen_string_literal: true

SIDEKIQ_CONFIG = YAML
                 .load_file(Schematics::Engine.join_config('sidekiq.yml'))
                 .freeze

case Tenant.storage
when Storage::Redis
  Sidekiq.configure_server do |config|
    config.merge!(SIDEKIQ_CONFIG)
    config.queues = SIDEKIQ_CONFIG[:queues]
    config.concurrency = SIDEKIQ_CONFIG[:concurrency]
  end

  Rollbar.configure do |config|
    config.use_sidekiq unless Rails.env.test?
  end
when Storage::Postgresql
  Rails.application.configure do
    config.good_job.execution_mode = :async
    config.good_job.enable_cron = true
    config.good_job.queues = SIDEKIQ_CONFIG[:queues].join(',')
    config.good_job.cron = SIDEKIQ_CONFIG[:schedule].deep_symbolize_keys
  end
end
