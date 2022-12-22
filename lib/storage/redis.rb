# frozen_string_literal: true

require 'sidekiq-scheduler/web'
require 'sidekiq/web'

module Storage
  class Redis
    def engine = ::Sidekiq::Web

    def engine_path = sidekiq_web_path

    def cache_store = :redis_cache_store

    def cache_store_options = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379') }

    def storage = Rack::MiniProfiler::RedisStore

    alias storage_options cache_store_options

    def queue_adapter
      return :test if Rails.env.test?

      :sidekiq
    end
  end
end
