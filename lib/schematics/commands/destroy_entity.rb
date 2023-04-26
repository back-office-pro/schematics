# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'
require 'rails/generators/rails/scaffold/scaffold_generator'
require 'generators/permissions/permissions_generator'
require 'generators/rspec/feature/feature_generator'
require 'generators/translations/translations_generator'

module Schematics
  module Commands
    class DestroyEntity < Command
      def generators = [
        scaffold_generator,
        feature_generator,
        translations_generator,
        permissions_generator,
        migration_generator,
        has_and_belongs_to_many_associations.map(&method(:drop_join_table_migration_generator))
      ].compact.flatten

      private

      def feature_generator
        return if core?

        Rspec::Generators::FeatureGenerator.new([name], [], behavior: :revoke)
      end

      def translations_generator
        return if core?

        TranslationsGenerator.new([name], [], behavior: :revoke)
      end

      def migration_generator = Rails::Generators::MigrationGenerator.new(
        ["drop_#{table_name.pluralize}", *migratable_attributes],
        ['--timestamps=true', '--primary_key_type=uuid']
      )

      def permissions_generator
        PermissionsGenerator.new([name], [], behavior: :revoke)
      end

      def scaffold_generator
        return if core?

        Rails::Generators::ScaffoldGenerator.new(
          [name, *migratable_attributes],
          ['--skip-resource-route', '--skip-migration'],
          behavior: :revoke
        )
      end

      def drop_join_table_migration_generator(association)
        Rails::Generators::MigrationGenerator.new(
          [
            "drop_join_table_#{association.entity.table_name.pluralize}_#{association.name}",
            association.entity.table_name.pluralize,
            association.name
          ]
        )
      end
    end
  end
end
