# frozen_string_literal: true

module Schematics
  module Commands
    class CreateEntity < Command
      def execute
        if model_exists?
          <<~SHELL
            rails generate scaffold_controller #{name} --skip-resource-route
          SHELL
        else
          [
            "rails generate scaffold #{name} #{migratable_attributes.map(&:to_s).join(' ')} --skip-resource-route", # rubocop:disable Layout/LineLength
            "rails generate fixtures #{name}",
            "rails generate migration add_slug_to_#{table_name.pluralize} slug:string:uniq",
            "rails generate migration add_lock_version_to_#{table_name.pluralize} lock_version:integer", # rubocop:disable Layout/LineLength
            has_and_belongs_to_many_associations.map(&method(:generate_create_join_table_migration)), # rubocop:disable Layout/LineLength
            association_attributes.map(&method(:generate_counter_cache_migration))
          ].flatten.map(&:squish)
        end
      end

      private

      def model_exists?
        Object.const_defined?(class_name)
      end

      def has_and_belongs_to_many_associations # rubocop:disable Naming/PredicateName
        super.reject { _1.entity.name.pluralize == _1.name }
      end

      def generate_create_join_table_migration(association)
        <<~SHELL
          rails generate migration create_join_table_#{association.entity.name.pluralize}_#{association.name} #{association.entity.name.pluralize}:join_table_first #{association.name}:join_table_second
        SHELL
      end

      def generate_counter_cache_migration(association)
        <<~SHELL
          rails generate migration add_#{association.inverse_association_name.pluralize}_count_to_#{association.association_type.pluralize} #{association.inverse_association_name.pluralize}_count:integer
        SHELL
      end
    end
  end
end
