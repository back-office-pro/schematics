# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Shards
    class List
      include Interactor

      delegate :root, :env, to: '::Rails', private: true
      delegate :adapter_name, to: 'ActiveRecord::Base.lease_connection', private: true

      def call
        context.shards = shards
      end

      private

      def shards # rubocop:disable Metrics/CyclomaticComplexity
        case adapter_name
        when 'SQLite'
          root
            .glob("storage/*/#{env}.sqlite3")
            .map(&:dirname)
            .map(&:basename)
            .map(&:to_s)
            .map(&:to_sym)
        when 'PostgreSQL'
          PG
            .connect(dbname: 'template1', connect_timeout: 1)
            .exec("SELECT datname FROM pg_database WHERE datistemplate = false AND datname LIKE '%_#{env}'") # rubocop:disable Layout/LineLength
            .values
            .flatten
            .map { _1.delete_suffix("_#{env}") }
            .map(&:to_sym)
        end
      end
    end
  end
end
