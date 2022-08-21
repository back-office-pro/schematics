# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/scaffold/scaffold_generator'
require 'rails/generators/rails/migration/migration_generator'
require 'generators/rspec/feature/feature_generator'
require 'generators/translations/translations_generator'
require 'generators/permissions/permissions_generator'

module Schematics
  module Commands
    class DestroyEntity < Command
      def generators = [
        scaffold_generator,
        feature_generator,
        translations_generator,
        permissions_generator,
        migration_generator
      ].compact.flatten

      private

      def feature_generator
        Rspec::Generators::FeatureGenerator.new([name], [], behavior: :revoke)
      end

      def translations_generator
        return if core?

        TranslationsGenerator.new([name], [], behavior: :revoke)
      end

      def migration_generator = Rails::Generators::MigrationGenerator.new(
        [
          "drop_#{table_name.pluralize}",
          *migratable_attributes.map(&:to_s)
        ]
      )

      def permissions_generator
        return if core?

        PermissionsGenerator.new([name], [], behavior: :revoke)
      end

      def scaffold_generator = Rails::Generators::ScaffoldGenerator.new(
        [
          name,
          *migratable_attributes.map(&:to_s)
        ],
        ['--skip-resource-route', '--skip-migration'],
        behavior: :revoke
      )
    end
  end
end
