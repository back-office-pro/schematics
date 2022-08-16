# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'

module Schematics
  module Commands
    class AddAttribute < Command
      def generators = [
        Rails::Generators::MigrationGenerator.new(
          [
            "add_#{attribute}_to_#{table_name.pluralize}",
            "schema:#{name}_#{attribute}"
          ]
        )
      ]
    end
  end
end
