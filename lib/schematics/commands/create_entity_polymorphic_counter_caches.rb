# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'

module Schematics
  module Commands
    class CreateEntityPolymorphicCounterCaches < Command
      def generators
        return super if existing?

        schema
          .polymorphic_associations
          .map(&:entity)
          .reject(&:existing?)
          .map(&method(:migration_generator))
      end

      def weight = 2

      private

      # # :reek:FeatureEnvy
      def migration_generator(entity)
        Rails::Generators::MigrationGenerator.new(
          [
            "add_#{entity.table_name.pluralize}_count_to_#{table_name.pluralize}",
            "#{entity.table_name.pluralize}_count:integer"
          ], ['--database=dummy']
        )
      end
    end
  end
end
