# frozen_string_literal: true

if Rails.env.development?
  Rack::MiniProfiler.config.tap do |config|
    config.position = 'bottom-left'
    config.enable_hotwire_turbo_drive_support = true
    config.skip_paths = [%r{/assets(.*)}]
  end
end
