# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'
require 'rails/generators/rails/scaffold/scaffold_generator'
require 'generators/permissions/permissions_generator'
require 'generators/rspec/feature/feature_generator'
require 'generators/translations/translations_generator'

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
          ].compact
        in :clean
          [
            scaffold_generator(behavior: :revoke),
            feature_generator(behavior: :revoke)
          ].compact
        end
      end

      private

      def feature_generator(behavior: :invoke)
        return if core?

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

      def permissions_generator
        PermissionsGenerator.new([name], ["--rename=#{old_class_name}"])
      end

      def scaffold_generator(behavior: :invoke)
        return if core?

        Rails::Generators::ScaffoldGenerator.new(
          [name, *migratable_attributes],
          ['--skip-resource-route', '--skip-migration'],
          behavior:
        )
      end

      def translations_generator
        return if core?

        TranslationsGenerator.new([name], ["--rename=#{old_name}"])
      end
    end
  end
end
