# frozen_string_literal: true

module Schematics
  class SchemaCache
    class << self
      delegate_missing_to :cache
      delegate :as_json, to: :cache

      def outdated?
        version != VERSION
      end

      private

      def cache
        Rails
          .cache
          .fetch('schema') { Schema.new(data:, version:) }
      rescue StandardError
        Schema.new(data:, version:)
      end

      def version
        ActiveRecord::Base
          .lease_connection
          .execute('SELECT core_version FROM documentations ORDER BY created_at DESC LIMIT 1')
          .first
          .fetch('core_version')
      rescue StandardError
        VERSION
      end

      def data
        JSON.parse ActiveRecord::Base
          .lease_connection
          .execute('SELECT data FROM migrations WHERE state IN (3, 4) ORDER BY created_at DESC LIMIT 1') # rubocop:disable Layout/LineLength
          .first
          .fetch('data')
      rescue StandardError
        []
      end
    end
  end
end
