# frozen_string_literal: true

Rack::MiniProfiler.config.tap do |config|
  config.position = 'bottom-left'
  config.start_hidden = Rails.env.production?
  config.snapshot_every_n_requests = 1
  config.authorization_mode = :allow_authorized
  config.base_url_path = '/profiler'
  config.enable_hotwire_turbo_drive_support = true
  config.storage = Tenant.storage.profiler_store
  config.storage_options = Tenant.storage.profiler_store_options
  config.skip_paths = [
    %r{/admin(.*)},
    %r{/favicon.ico},
    %r{/assets(.*)}
  ]
end
