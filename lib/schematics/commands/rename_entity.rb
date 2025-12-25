# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'
require 'generators/permissions/permissions_generator'
require 'generators/translations/translations_generator'
require 'generators/translation/translation_generator'

module Schematics
  module Commands
    class RenameEntity < Command
      def generators = [
        translations_generator,
        translatable_elements.map(&method(:translation_generator)),
        permissions_generator,
        migration_generator,
        has_and_belongs_to_many_associations.map(&method(:rename_join_table_migration_generator)),
        has_and_belongs_to_many_associations.map(&method(:rename_column_migration_generator))
      ].flatten.compact

      private

      def translations_generator
        return if core?

        TranslationsGenerator.new([name], ["--rename=#{old_name}"])
      end

      # :reek:FeatureEnvy
      def translation_generator(element)
        return if core?

        TranslationGenerator.new(
          [element.i18n_key],
          [
            [
              '--rename=',
              element.i18n_key.gsub(
                "activerecord.#{element.i18n_scope}.#{name}",
                "activerecord.#{element.i18n_scope}.#{old_name}"
              )
            ].join
          ]
        )
      end

      def old_name = attribute.name

      def permissions_generator = PermissionsGenerator.new(
        [class_name],
        ["--rename=#{old_class_name}"]
      )

      def old_class_name = old_name.camelize

      def migration_generator = Rails::Generators::MigrationGenerator.new(
        ["rename_#{old_table_name.pluralize}_to_#{table_name.pluralize}"]
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
