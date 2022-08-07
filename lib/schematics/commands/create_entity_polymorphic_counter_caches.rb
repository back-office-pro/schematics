# frozen_string_literal: true

module Schematics
  module Commands
    class CreateEntityPolymorphicCounterCaches < CreateEntityCounterCaches
      def execute
        return [] if model_exists?

        Schema
          .instance
          .polymorphic_associations
          .reject { Object.const_defined?(_1.entity.class_name) }
          .map(&:entity)
          .map(&method(:generate_counter_cache_migration))
          .map(&:squish)
      end

      private

      # # :reek:FeatureEnvy
      def generate_counter_cache_migration(entity)
        <<~SHELL
          rails generate migration add_#{entity.table_name.pluralize}_count_to_#{table_name.pluralize} #{entity.table_name.pluralize}_count:integer
        SHELL
      end
    end
  end
end
