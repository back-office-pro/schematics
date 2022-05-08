# frozen_string_literal: true

module Schematics
  module Behaviours
    module Migratable
      def column_name = name

      def type
        self.class.name.demodulize.underscore
      end

      alias database_type type

      def id
        [entity.table_name, name].join('_')
      end

      def to_s
        "schema:#{id}"
      end

      def options_for_migration
        options.slice(*migration_options)
      end

      protected

      def migration_options = []
    end
  end
end
