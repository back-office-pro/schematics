# frozen_string_literal: true

module Schematics
  module Storage
    class Postgres
      def engine = ::GoodJob::Engine

      def engine_path = good_job_path

      def cache_store = :memory_store

      def cache_store_options = {}

      def profiler_store = Rack::MiniProfiler::MemoryStore

      alias profiler_store_options cache_store_options

      def queue_adapter
        return :test if Rails.env.test?

        :good_job
      end
    end
  end
end
