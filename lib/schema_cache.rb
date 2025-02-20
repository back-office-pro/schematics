# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class SchemaCache
  class << self
    delegate_missing_to :cache
    delegate :as_json, to: :cache

    private

    def cache = Rails
      .cache
      .fetch('schema') { Schematics::Schema.new(data:, version:) }

    def version
      ActiveRecord::Base
        .lease_connection
        .execute('SELECT core_version FROM documentations ORDER BY created_at DESC LIMIT 1')
        .first
        .fetch('core_version')
    rescue StandardError
      Schematics::VERSION
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
