# frozen_string_literal: true

module Backend
  # :reek:UtilityFunction
  class Postgresql
    delegate :middleware, to: :engine, prefix: true

    def concurrency = 0

    def max_threads = 13

    def engine = ::GoodJob::Engine

    def cache_store = :solid_cache_store

    def cache_store_options = {
      active_record_instrumentation: false,
      expiry_method: :job,
      expiry_queue: :cleanups,
      max_age: 2.weeks.to_i,
      max_entries: 2000,
      max_size: 1.gigabyte
    }

    def profiler_store = Rack::MiniProfiler::MemoryStore

    def profiler_store_options = nil

    def queue_adapter = :good_job
  end
end
