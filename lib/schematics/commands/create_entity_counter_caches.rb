# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'

module Schematics
  module Commands
    class CreateEntityCounterCaches < Command
      def generators
        return super if existing?

        association_attributes
          .reject(&:polymorphic?)
          .map(&method(:migration_generator))
      end

      def weight = 2

      private

      def migration_generator(association)
        Rails::Generators::MigrationGenerator.new(
          [
            "add_#{association.inverse_association_name.pluralize}_count_to_#{association.association_type.pluralize}", # rubocop:disable Layout/LineLength
            "#{association.inverse_association_name.pluralize}_count:integer"
          ], ['--database=dummy']
        )
      end
    end
  end
end
