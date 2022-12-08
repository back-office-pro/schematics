# frozen_string_literal: true

require 'generators/permissions/permissions_generator'
require 'generators/rspec/feature/feature_generator'
require 'generators/translations/translations_generator'
require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'
require 'rails/generators/rails/scaffold/scaffold_generator'

module Schematics
  module Commands
    class RenameEntity < Command
      def generators
        case target
        in :build
          [
            migration_generator,
            scaffold_generator,
            feature_generator,
            translations_generator,
            permissions_generator
          ]
        in :clean
          [
            scaffold_generator(behavior: :revoke),
            feature_generator(behavior: :revoke)
          ]
        end
      end

      private

      def feature_generator(behavior: :invoke)
        Rspec::Generators::FeatureGenerator.new([name], [], behavior:)
      end

      def migration_generator = Rails::Generators::MigrationGenerator.new(
        [
          "rename_#{old_table_name.pluralize}_to_#{table_name.pluralize}"
        ]
      )

      def old_class_name = old_name.camelize

      def old_name = attribute

      def old_table_name = old_name.tr('/', '_')

      def permissions_generator = PermissionsGenerator.new(
        [name],
        ["--rename=#{old_class_name}"]
      )

      def scaffold_generator(behavior: :invoke)
        Rails::Generators::ScaffoldGenerator.new(
          [
            name,
            *migratable_attributes.map(&:to_s)
          ],
          ['--skip-resource-route', '--skip-migration'],
          behavior:
        )
      end

      def translations_generator = TranslationsGenerator.new(
        [name],
        ["--rename=#{old_name}"]
      )
    end
  end
end
