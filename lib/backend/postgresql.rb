# frozen_string_literal: true

module Backend
  # :reek:UtilityFunction
  class Postgresql
    delegate :middleware, to: :engine, prefix: true

    def concurrency = 0

    def mutex = Mutex.new

    def engine = ::GoodJob::Engine

    def cache_store = :memory_store

    def cache_store_options = { size: 64.megabytes }

    def profiler_store = Rack::MiniProfiler::MemoryStore

    alias profiler_store_options cache_store_options

    def queue_adapter
      return :test if Rails.env.test?

      :good_job
    end
  end
end
