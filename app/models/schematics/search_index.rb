# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class SearchIndex < ::ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
    self.table_name = :search_indexes # rubocop:disable Rails/TableNameAssignment

    class << self
      def insert_sql(*values)
        lease_connection.execute sanitize_sql(
          [
            <<~SQL.squish, *values
              INSERT INTO #{table_name} (content, searchable_type, searchable_id)
              VALUES (:content, :searchable_type, :searchable_id)
            SQL
          ]
        )
      end
    end
  end
end
