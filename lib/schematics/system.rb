# frozen_string_literal: true

module Schematics
  module System
    class << self
      def generate(entity)
        [
          generate_scaffold(entity.name, entity.migratable_attributes),
          generate_rspec_acceptance(entity.name),
          generate_deleted_at_migration(entity.name),
          generate_slug_migration(entity.name),
          (generate_ancestry_migration(entity.name) if entity.is_a?(Entities::Tree)),
          entity
            .has_and_belongs_to_many_associations
            .reject { _1.entity.name.pluralize == _1.name }
            .map(&method(:generate_join_table_migration)),
          entity
            .association_attributes
            .map(&method(:generate_counter_cache_migration))
        ].flatten.compact.map(&:squish)
      end

      def destroy_entity(entity)
        [
          destroy_scaffold(entity.name),
          destroy_rspec_acceptance(entity.name),
          generate_drop_table_migration(entity.name, entity.migratable_attributes)
        ].map(&:squish)
      end

      def destroy_entity_attribute(entity, attribute)
        [
          generate_remove_attribute_migration(entity.name, attribute)
        ].map(&:squish)
      end

      private

      def generate_counter_cache_migration(association)
        <<~SHELL
          rails generate migration add_#{association.inverse_association_name.pluralize}_count_to_#{association.association_type.pluralize} #{association.inverse_association_name.pluralize}_count:integer
        SHELL
      end

      def generate_join_table_migration(association)
        <<~SHELL
          rails generate migration create_join_table_#{association.entity.name.pluralize}_#{association.name} #{association.entity.name.pluralize} #{association.name}:join_table_uuid
        SHELL
      end

      def generate_scaffold(name, attributes)
        <<~SHELL
          rails generate scaffold #{name} #{attributes.map(&:to_s).join(' ')} --skip-resource-route
        SHELL
      end

      def generate_rspec_acceptance(name)
        <<~SHELL
          rails generate rspec:acceptance #{name}
        SHELL
      end

      def generate_deleted_at_migration(name)
        <<~SHELL
          rails generate migration add_deleted_at_to_#{name.pluralize} deleted_at:datetime
        SHELL
      end

      def generate_slug_migration(name)
        <<~SHELL
          rails generate migration add_slug_to_#{name.pluralize} slug:string:uniq
        SHELL
      end

      def generate_ancestry_migration(name)
        <<~SHELL
          rails generate migration add_ancestry_to_#{name.pluralize} ancestry:string
        SHELL
      end

      def destroy_scaffold(name)
        <<~SHELL
          rails destroy scaffold #{name} --skip-migration --skip-resource-route
        SHELL
      end

      def generate_drop_table_migration(name, attributes)
        <<~SHELL
          rails generate migration drop_#{name.pluralize}_table #{attributes.map(&:to_s).join(' ')}
        SHELL
      end

      def destroy_rspec_acceptance(name)
        <<~SHELL
          rails destroy rspec:acceptance #{name}
        SHELL
      end

      def generate_remove_attribute_migration(name, attribute)
        <<~SHELL
          rails generate migration remove_#{attribute}_from_#{name.pluralize} schema:#{name}_#{attribute}
        SHELL
      end
    end
  end
end
