# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379') }
  config[:queues] = %w[default searchkick rollbar mailers]
  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file Schematics::Engine.join_config('scheduler.yml')
    Sidekiq::Scheduler.reload_schedule!
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379') }
end
