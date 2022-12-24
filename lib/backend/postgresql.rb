# frozen_string_literal: true

module Backend
  class Postgresql
    def engine = ::GoodJob::Engine

    # :reek:UtilityFunction
    def engine_path = Rails
      .application
      .routes
      .url_helpers
      .good_job_path

    def cache_store = :memory_store

    def cache_store_options = {}

    def profiler_store = Rack::MiniProfiler::MemoryStore

    alias profiler_store_options cache_store_options

    # :reek:UtilityFunction
    def queue_adapter
      return :test if Rails.env.test?

      :good_job
    end
  end
end
