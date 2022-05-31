# frozen_string_literal: true

module Schematics
  module Behaviours
    module Migratable
      def column_name = name

      def database_index_type = :btree

      def id = [
        entity.table_name,
        name
      ].join('_')

      def migration_options = {}

      def to_s = "schema:#{id}"

      def type = self
        .class
        .name
        .demodulize
        .underscore

      alias database_type type
    end
  end
end
