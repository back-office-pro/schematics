# frozen_string_literal: true

require 'sidekiq-scheduler/web'
require 'sidekiq/web'

Sidekiq.configure_server do |config|
  opts = YAML.load_file Schematics::Engine.join_config('backend.yml')
  config.merge!(opts)
  config.queues = opts[:queues]
  config.concurrency = opts[:concurrency]
end
