# frozen_string_literal: true

module Schematics
  module Behaviours
    module Migratable
      def column_name = name

      def id
        [entity.table_name, name].join('_')
      end

      def options_for_migration
        options.slice(*migration_options)
      end

      def to_s = "schema:#{id}"

      def type
        self.class.name.demodulize.underscore
      end

      protected

      def migration_options = []
    end
  end
end
