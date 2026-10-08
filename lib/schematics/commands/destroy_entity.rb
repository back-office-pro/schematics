# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'
require 'generators/permissions/permissions_generator'
require 'generators/translations/translations_generator'
require 'generators/translation/translation_generator'

module Schematics
  module Commands
    class DestroyEntity < Command
      def generators = [
        translations_generator,
        translatable_elements.map(&method(:translation_generator)),
        permissions_generator,
        migration_generator,
        has_and_belongs_to_many_associations.map(&method(:drop_join_table_migration_generator))
      ].flatten.compact

      private

      def translations_generator
        return if core?

        TranslationsGenerator.new([name], [], behavior: :revoke)
      end

      def translation_generator(element)
        return if core?

        TranslationGenerator.new([element.i18n_key], [], behavior: :revoke)
      end

      def permissions_generator
        return if abstract?

        PermissionsGenerator.new([class_name], [], behavior: :revoke)
      end

      def migration_generator
        return if child?

        Rails::Generators::MigrationGenerator.new(
          ["drop_#{table_name.pluralize}", *migratable_attributes.map(&:to_s)],
          ['--timestamps=true', '--primary_key_type=string']
        )
      end

      # :reek:FeatureEnvy
      def drop_join_table_migration_generator(association)
        Rails::Generators::MigrationGenerator.new(
          [
            "drop_join_table_#{association.join_table}",
            association.source_entity.table_name.pluralize,
            association.inverse_entity.table_name.pluralize
          ]
        )
      end
    end
  end
end
