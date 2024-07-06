# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'
require 'generators/translation/translation_generator'

module Schematics
  module Commands
    class AddAssociation < Command
      def generators = [migration_generator, translation_generator].compact

      def migration_generator = Rails::Generators::MigrationGenerator.new(
        [
          "create_join_table_#{table_name.pluralize}_#{attribute.name}",
          table_name.pluralize,
          attribute.name
        ]
      )

      def translation_generator
        return if core?

        TranslationGenerator.new([attribute.i18n_key])
      end

      def weight = 2
    end
  end
end
