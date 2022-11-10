# frozen_string_literal: true

Rack::MiniProfiler.config.tap do |config|
  config.position = 'bottom-left'
  config.start_hidden = Rails.env.production?
  config.snapshot_every_n_requests = 1
  config.authorization_mode = :allow_authorized
  config.base_url_path = '/profiler'
  config.enable_hotwire_turbo_drive_support = true
  config.storage = Rack::MiniProfiler::RedisStore
  config.storage_options = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379') }
  config.skip_paths = [
    %r{/sidekiq(.*)},
    %r{/favicon.ico},
    %r{/api},
    %r{/assets(.*)}
  ]
end
