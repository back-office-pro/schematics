# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'

module Schematics
  module Commands
    class CreateEntityPolymorphicCounterCaches < Command
      def generators
        return super if model_exists?

        Schema
          .instance
          .polymorphic_associations
          .reject { Object.const_defined?(_1.entity.class_name) }
          .map(&:entity)
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
          ]
        )
      end
    end
  end
end
