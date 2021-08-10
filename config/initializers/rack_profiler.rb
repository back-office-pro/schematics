# frozen_string_literal: true

Rack::MiniProfiler.config.tap do |config|
  config.storage_options = { url: ENV['REDIS_URL'] }
  config.storage = Rack::MiniProfiler::RedisStore
  config.position = 'bottom-left'
  config.start_hidden = Rails.env.production?
  config.snapshot_every_n_requests = 1
  config.authorization_mode = :allow_authorized
  config.base_url_path = '/profiler'
  config.skip_paths = [
    %r{/sidekiq(.*)},
    %r{/favicon.ico},
    %r{/api},
    %r{/assets(.*)}
  ]
end
