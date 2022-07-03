# frozen_string_literal: true

module Schematics
  module Commands
    class CreateEntityCounterCaches < Command
      def execute
        return [] if model_exists?

        association_attributes
          .reject(&:polymorphic?)
          .map(&method(:generate_counter_cache_migration))
          .map(&:squish)
      end

      def weight = 2

      private

      def generate_counter_cache_migration(association)
        <<~SHELL
          rails generate migration add_#{association.inverse_association_name.pluralize}_count_to_#{association.association_type.pluralize} #{association.inverse_association_name.pluralize}_count:integer
        SHELL
      end

      def model_exists?
        Object.const_defined?(class_name)
      end
    end
  end
end
