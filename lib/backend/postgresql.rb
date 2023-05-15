# frozen_string_literal: true

module Backend
  # :reek:UtilityFunction
  class Postgresql
    delegate :middleware, to: :engine, prefix: true

    def concurrency = 0

    def engine = ::GoodJob::Engine

    def cache_store = :file_store

    def cache_store_options = ::Rails.root.join('tmp/cache')

    def profiler_store = Rack::MiniProfiler::MemoryStore

    def profiler_store_options = nil

    def queue_adapter = :good_job
  end
end
