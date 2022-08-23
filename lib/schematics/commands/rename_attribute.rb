# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'

module Schematics
  module Commands
    class RenameAttribute < Command
      def generators = [
        Rails::Generators::MigrationGenerator.new(
          [
            "rename_#{attribute}_to_#{target}_in_#{table_name.pluralize}"
          ]
        )
      ]

      def weight = 3
    end
  end
end
