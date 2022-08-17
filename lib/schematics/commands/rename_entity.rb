# frozen_string_literal: true

module Schematics
  module Commands
    class RenameEntity < Command
      def generators = [
        Rails::Generators::MigrationGenerator.new(
          [
            "rename_#{old_table_name.pluralize}_to_#{table_name.pluralize}"
          ]
        )
      ]

      private

      def old_class_name = old_name.camelize

      def old_name = attribute

      def old_table_name = old_name.tr('/', '_')
    end
  end
end
