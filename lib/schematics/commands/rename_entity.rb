# frozen_string_literal: true

module Schematics
  module Commands
    class RenameEntity < Command
      def execute = [
        "rails generate migration rename_#{old_table_name.pluralize}_to_#{table_name.pluralize}",
        "rails destroy scaffold #{old_name} --skip-migration --skip-resource-route",
        "rails destroy fixtures #{old_name}",
        "rails generate fixtures #{name}",
        "rails destroy locales #{old_name}",
        "rails generate locales #{name}",
        "rails 'schematics:permissions:rename[#{old_class_name},#{class_name}]'"
      ]

      private

      def old_class_name = old_name.camelize

      def old_name = attribute

      def old_table_name = old_name.tr('/', '_')
    end
  end
end
