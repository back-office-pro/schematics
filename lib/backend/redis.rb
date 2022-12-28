# frozen_string_literal: true

require 'backend/concurrent_mutex'

module Backend
  # :reek:UtilityFunction
  class Redis
    def concurrency = 2

    def mutex = ConcurrentMutex.new

    def engine = ::Sidekiq::Web

    def engine_path = Rails
      .application
      .routes
      .url_helpers
      .sidekiq_web_path

    def cache_store = :redis_cache_store

    def cache_store_options = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379') }

    def profiler_store = Rack::MiniProfiler::RedisStore

    alias profiler_store_options cache_store_options

    def queue_adapter
      return :test if Rails.env.test?

      :sidekiq
    end
  end
end
