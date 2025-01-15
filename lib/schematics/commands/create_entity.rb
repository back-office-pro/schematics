# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'
require 'generators/permissions/permissions_generator'
require 'generators/translations/translations_generator'

module Schematics
  module Commands
    class CreateEntity < Command
      def generators = [
        translations_generator,
        permissions_generator,
        migration_generator,
        has_and_belongs_to_many_associations.map(&method(:create_join_table_migration_generator))
      ].compact.flatten

      private

      def translations_generator
        return if core?

        TranslationsGenerator.new([name])
      end

      def permissions_generator
        return if core?

        PermissionsGenerator.new([name])
      end

      def migration_generator
        return if existing?

        Rails::Generators::MigrationGenerator.new(
          ["create_#{table_name.pluralize}", *migratable_attributes],
          ['--timestamps=true', '--primary_key_type=string']
        )
      end

      # :reek:FeatureEnvy
      def create_join_table_migration_generator(association)
        return if existing?

        Rails::Generators::MigrationGenerator.new(
          [
            "create_join_table_#{association.join_table}",
            association.entity.table_name.pluralize,
            "#{association.inverse_entity.table_name.pluralize}:uniq"
          ]
        )
      end
    end
  end
end
