# Copyright © 2025 Dev & Software. All rights reserved.

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
require 'generators/permission/permission_generator'
require 'generators/translations/translations_generator'
require 'generators/translation/translation_generator'

module Schematics
  module Commands
    class CreateEntity < Command
      def generators = [
        translations_generator,
        translatable_elements.map(&method(:translation_generator)),
        actions_with_events.map(&method(:permission_generator)),
        migration_generator,
        has_and_belongs_to_many_associations.map(&method(:create_join_table_migration_generator))
      ].flatten.compact

      private

      def translations_generator
        return if core?

        TranslationsGenerator.new([name])
      end

      def translation_generator(element)
        return if core?

        TranslationGenerator.new([element.i18n_key])
      end

      def permission_generator(action)
        return if core?
        return if abstract?

        PermissionGenerator.new([class_name], ["--action=#{action}"])
      end

      def migration_generator
        return if existing?
        return if child?

        Rails::Generators::MigrationGenerator.new(
          ["create_#{table_name.pluralize}", *migratable_attributes.map(&:to_s)],
          ['--timestamps=true', '--primary_key_type=string']
        )
      end

      # :reek:FeatureEnvy
      def create_join_table_migration_generator(association)
        return if existing?

        Rails::Generators::MigrationGenerator.new(
          [
            "create_join_table_#{association.join_table}",
            association.source_entity.table_name.pluralize,
            "#{association.inverse_entity.table_name.pluralize}:uniq"
          ]
        )
      end
    end
  end
end
