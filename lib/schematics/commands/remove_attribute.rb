# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'

module Schematics
  module Commands
    class RemoveAttribute < Command
      def generators = [
        Rails::Generators::MigrationGenerator.new(
          [
            "remove_#{attribute}_from_#{table_name.pluralize}",
            "schema:#{name}_#{attribute}"
          ]
        )
      ]

      def weight = 3
    end
  end
end
