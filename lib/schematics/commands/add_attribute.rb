# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'
require 'generators/translation/translation_generator'

module Schematics
  module Commands
    class AddAttribute < Command
      def generators = [migration_generator, translation_generator].compact

      def migration_generator
        case attribute
        when Behaviours::Migratable
          Rails::Generators::MigrationGenerator.new(
            ["add_#{attribute.name}_to_#{table_name.pluralize}", attribute.to_s],
            ['--primary_key_type=string']
          )
        end
      end

      def translation_generator
        return if core?

        TranslationGenerator.new([attribute.i18n_key])
      end

      def weight = 2
    end
  end
end
