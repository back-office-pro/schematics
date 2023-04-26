# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'
require 'generators/translation/translation_generator'

module Schematics
  module Commands
    class RenameAttribute < Command
      def generators = [migration_generator, translation_generator].compact

      def migration_generator = Rails::Generators::MigrationGenerator.new(
        [
          "rename_#{attribute}_to_#{target}_in_#{table_name.pluralize}"
        ]
      )

      def translation_generator
        return if core?

        TranslationGenerator.new(
          ["attributes.#{name}.#{target}"],
          ["--rename=attributes.#{name}.#{attribute}"],
          behavior: :revoke
        )
      end

      def weight = 3
    end
  end
end
