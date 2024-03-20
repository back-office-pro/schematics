# frozen_string_literal: true

require 'sidekiq-scheduler/web'
require 'sidekiq/web'

module Backend
  # :reek:UtilityFunction
  class Redis
    def concurrency = 2

    def max_threads = 3

    def engine = ::Sidekiq::Web

    def cache_store = :redis_cache_store

    def cache_store_options = {
      url: ENV.fetch('REDIS_URL', 'redis://localhost:6379'),
      connect_timeout: 1,
      timeout: 1
    }

    def profiler_store = Rack::MiniProfiler::RedisStore

    alias profiler_store_options cache_store_options

    def queue_adapter = :sidekiq
  end
end
