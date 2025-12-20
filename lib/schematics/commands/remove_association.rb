# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'
require 'generators/translation/translation_generator'

module Schematics
  module Commands
    class RemoveAssociation < Command
      def generators = [migration_generator, translation_generator].compact

      def migration_generator = Rails::Generators::MigrationGenerator.new(
        [
          "drop_join_table_#{attribute.join_table}",
          table_name.pluralize,
          attribute.name
        ]
      )

      def translation_generator
        return if core?

        TranslationGenerator.new([attribute.i18n_key], [], behavior: :revoke)
      end

      def weight = 2
    end
  end
end
