# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'

module Schematics
  module Commands
    class ChangeAttribute < Command
      def generators
        case attribute
        when Behaviours::Migratable
          [
            Rails::Generators::MigrationGenerator.new(
              [
                "change_#{attribute.column_name}_column_#{target.database_type}_in_#{table_name.pluralize}", # rubocop:disable Layout/LineLength
                attribute.to_s
              ], ["--database=#{database}"]
            )
          ]
        else
          super
        end
      end

      def weight = 2
    end
  end
end
