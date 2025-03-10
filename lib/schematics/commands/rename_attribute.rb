# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'
require 'generators/translation/translation_generator'

module Schematics
  module Commands
    class RenameAttribute < Command
      def generators = [migration_generator, translation_generator].compact

      def migration_generator
        case attribute
        when Behaviours::Migratable
          Rails::Generators::MigrationGenerator.new(
            ["rename_#{attribute.column_name}_to_#{target.column_name}_in_#{table_name.pluralize}"],
            ["--database=#{database}"]
          )
        end
      end

      def translation_generator
        return if core?

        TranslationGenerator.new(
          [target.i18n_key],
          ["--rename=#{attribute.i18n_key}"]
        )
      end

      def weight = 2
    end
  end
end
