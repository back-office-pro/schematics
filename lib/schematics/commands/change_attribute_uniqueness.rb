# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'

module Schematics
  module Commands
    class ChangeAttributeUniqueness < Command
      def generators = [
        Rails::Generators::MigrationGenerator.new(
          [
            "change_#{attribute.column_name}_index_in_#{table_name.pluralize}",
            attribute.to_s
          ]
        )
      ]

      def weight = 3
    end
  end
end
