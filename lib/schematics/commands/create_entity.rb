# frozen_string_literal: true

module Schematics
  module Commands
    class CreateEntity < Command
      def execute
        return generate_scaffold_controller if model_exists?

        [
          "rails generate scaffold #{name} #{migratable_attributes} --skip-resource-route",
          "rails generate rspec:feature #{name}",
          ("rails generate locales #{name}" unless core?),
          "rails generate migration add_slug_to_#{table_name.pluralize} slug:string:uniq",
          "rails generate migration add_lock_version_to_#{table_name.pluralize} lock_version:integer", # rubocop:disable Layout/LineLength
          has_and_belongs_to_many_associations.map(&method(:generate_create_join_table_migration)),
          association_attributes.map(&method(:generate_counter_cache_migration)),
          ("rails 'schematics:permissions:create[#{class_name}]'" unless core?)
        ].compact.flatten.map(&:squish)
      end

      private

      def association_attributes
        super.reject(&:polymorphic?)
      end

      def generate_counter_cache_migration(association)
        <<~SHELL
          rails generate migration add_#{association.inverse_association_name.pluralize}_count_to_#{association.association_type.pluralize} #{association.inverse_association_name.pluralize}_count:integer
        SHELL
      end

      def generate_create_join_table_migration(association)
        <<~SHELL
          rails generate migration create_join_table_#{association.entity.name.pluralize}_#{association.name} #{association.entity.name.pluralize}:join_table_first #{association.name}:join_table_second
        SHELL
      end

      def generate_scaffold_controller = <<~SHELL
        rails generate scaffold_controller #{name} --skip-resource-route
      SHELL

      # :reek:FeatureEnvy
      def has_and_belongs_to_many_associations # rubocop:disable Naming/PredicateName
        super.reject { _1.entity.name.pluralize == _1.name }
      end

      def migratable_attributes = super
        .map(&:to_s)
        .join(' ')

      def model_exists?
        Object.const_defined?(class_name)
      end
    end
  end
end
