# frozen_string_literal: true

module Storage
  class Redis
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

    def initializer
      Sidekiq.configure_server do |config|
        opts = YAML.load_file Schematics::Engine.join_config('sidekiq.yml')
        config.merge!(opts)
        config.queues = opts[:queues]
        config.concurrency = opts[:concurrency]
      end

      Rollbar.configure do |config|
        config.use_sidekiq unless Rails.env.test?
      end
    end
  end
end
