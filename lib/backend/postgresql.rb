# frozen_string_literal: true

module Backend
  # :reek:UtilityFunction
  class Postgresql
    delegate :middleware, to: :engine, prefix: true

    def concurrency = 0

    def engine = ::GoodJob::Engine

    def cache_store = :solid_cache_store

    def cache_store_options = {}

    def profiler_store = Rack::MiniProfiler::MemoryStore

    alias profiler_store_options cache_store_options

    def queue_adapter = :good_job
  end
end
