# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/scaffold_controller/scaffold_controller_generator'
require 'rails/generators/rails/scaffold/scaffold_generator'
require 'rails/generators/rails/migration/migration_generator'
require 'generators/rspec/feature/feature_generator'
require 'generators/translations/translations_generator'
require 'generators/permissions/permissions_generator'

module Schematics
  module Commands
    class CreateEntity < Command
      def generators
        return [scaffold_controller_generator] if model_exists?

        [
          scaffold_generator,
          feature_generator,
          translations_generator,
          permissions_generator,
          slug_migration_generator,
          lock_version_migration_generator,
          has_and_belongs_to_many_associations.map(&method(:create_join_table_migration_generator))
        ].compact.flatten
      end

      private

      def scaffold_generator = Rails::Generators::ScaffoldGenerator.new(
        [
          name,
          *migratable_attributes.map(&:to_s)
        ], ['--skip-resource-route']
      )

      def feature_generator = Rspec::Generators::FeatureGenerator.new([name])

      def translations_generator
        return if core?

        TranslationsGenerator.new([name])
      end

      def permissions_generator
        return if core?

        PermissionsGenerator.new([name])
      end

      def slug_migration_generator = Rails::Generators::MigrationGenerator.new(
        [
          "add_slug_to_#{table_name.pluralize}",
          'slug:string:uniq'
        ]
      )

      def lock_version_migration_generator = Rails::Generators::MigrationGenerator.new(
        [
          "add_lock_version_to_#{table_name.pluralize}",
          'lock_version:integer'
        ]
      )

      def create_join_table_migration_generator(association)
        Rails::Generators::MigrationGenerator.new(
          [
            "create_join_table_#{association.entity.name.pluralize}_#{association.name}",
            "#{association.entity.name.pluralize}:join_table_first",
            "#{association.name}:join_table_second"
          ]
        )
      end

      def scaffold_controller_generator
        Rails::Generators::ScaffoldControllerGenerator.new([name], ['--skip-resource-route'])
      end
    end
  end
end
