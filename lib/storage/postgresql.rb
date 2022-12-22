# frozen_string_literal: true

module Storage
  class Postgresql
    def engine = ::GoodJob::Engine

    def engine_path = good_job_path

    def cache_store = :memory_store

    def cache_store_options = nil

    def profiler_store = Rack::MiniProfiler::MemoryStore

    alias profiler_store_options cache_store_options

    def queue_adapter
      return :test if Rails.env.test?

      :good_job
    end

    def initializer
      Rails.application.configure do
        opts = YAML.load_file Schematics::Engine.join_config('sidekiq.yml')
        config.good_job.execution_mode = :async
        config.good_job.enable_cron = true
        config.good_job.queues = opts[:queues]
        config.good_job.cron = opts[:schedule]
      end
    end
  end
end
