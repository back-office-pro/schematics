# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'
require 'rails/generators/rails/model/model_generator'
require 'generators/permissions/permissions_generator'
require 'generators/translations/translations_generator'

module Schematics
  module Commands
    class DestroyEntity < Command
      def generators = [
        model_generator,
        translations_generator,
        permissions_generator,
        migration_generator,
        has_and_belongs_to_many_associations.map(&method(:drop_join_table_migration_generator))
      ].compact.flatten

      private

      def model_generator
        return if core?

        Rails::Generators::ModelGenerator.new(
          [name, *migratable_attributes],
          ['--skip-migration'],
          behavior: :revoke
        )
      end

      def translations_generator
        return if core?

        TranslationsGenerator.new([name], [], behavior: :revoke)
      end

      def permissions_generator
        PermissionsGenerator.new([name], [], behavior: :revoke)
      end

      def migration_generator = Rails::Generators::MigrationGenerator.new(
        ["drop_#{table_name.pluralize}", *migratable_attributes],
        ['--timestamps=true', '--primary_key_type=string']
      )

      def drop_join_table_migration_generator(association)
        Rails::Generators::MigrationGenerator.new(
          [
            "drop_join_table_#{association.join_table}",
            association.entity.table_name.pluralize,
            association.inverse_entity.table_name.pluralize
          ]
        )
      end
    end
  end
end
