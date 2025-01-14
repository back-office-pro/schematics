# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'
require 'rails/generators/rails/model/model_generator'
require 'generators/permissions/permissions_generator'
require 'generators/rspec/feature/feature_generator'
require 'generators/translations/translations_generator'

module Schematics
  module Commands
    class RenameEntity < Command
      def generators
        case target
        when :build
          [
            model_generator,
            translations_generator,
            permissions_generator,
            migration_generator,
            has_and_belongs_to_many_associations.map(&method(:rename_join_table_migration_generator)), # rubocop:disable Layout/LineLength
            has_and_belongs_to_many_associations.map(&method(:rename_column_migration_generator))
          ].compact.flatten
        when :clean
          [model_generator(behavior: :revoke)].compact
        end
      end

      private

      def model_generator(behavior: :invoke)
        return if core?

        Rails::Generators::ModelGenerator.new(
          [name, *migratable_attributes],
          ['--skip-migration'],
          behavior:
        )
      end

      def translations_generator
        return if core?

        TranslationsGenerator.new([name], ["--rename=#{old_name}"])
      end

      def old_name = attribute.name

      def permissions_generator = PermissionsGenerator.new(
        [name],
        ["--rename=#{old_class_name}"]
      )

      def old_class_name = old_name.camelize

      def migration_generator = Rails::Generators::MigrationGenerator.new(
        [
          "rename_#{old_table_name.pluralize}_to_#{table_name.pluralize}"
        ]
      )

      def old_table_name = old_name.tr('/', '_')

      # :reek:FeatureEnvy
      def rename_join_table_migration_generator(association)
        Rails::Generators::MigrationGenerator.new(
          [
            [
              'rename',
              old_name.pluralize,
              association.inverse_entity.table_name.pluralize,
              'to',
              association.join_table
            ].join('_')
          ]
        )
      end

      # :reek:FeatureEnvy
      def rename_column_migration_generator(association)
        Rails::Generators::MigrationGenerator.new(
          [
            [
              'rename',
              "#{old_name}_id",
              'to',
              "#{association.entity.table_name}_id",
              'in',
              association.join_table
            ].join('_')
          ]
        )
      end
    end
  end
end
