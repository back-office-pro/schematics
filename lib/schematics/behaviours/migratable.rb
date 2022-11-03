# frozen_string_literal: true

module Schematics
  module Behaviours
    module Migratable
      def column_name = name

      def database_index_type = :btree

      def migration_options = {}

      def prefixed_name = "#{entity.table_name}_#{name}"

      def to_s = "schema:#{prefixed_name}"

      def database_type = type
    end
  end
end
