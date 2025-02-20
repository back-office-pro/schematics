# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rack-mini-profiler'

Rack::MiniProfilerRails.initialize!(Rails.application) if Rails.env.development?

Rack::MiniProfiler.config.tap do |config|
  config.position = 'bottom-left'
  config.start_hidden = Rails.env.production?
  config.snapshot_every_n_requests = 1
  config.authorization_mode = :allow_authorized
  config.base_url_path = '/profiler'
  config.enable_hotwire_turbo_drive_support = true
  config.storage = Rack::MiniProfiler::MemoryStore
  config.skip_paths = [%r{/assets(.*)}]
end
