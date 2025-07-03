# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module ActiveRecord
  module Override
    module Generators
      module MigrationGenerator
        def set_local_assigns! # rubocop:disable Metrics/CyclomaticComplexity
          case file_name
          when /^drop_join_table_(.+)/
            @join_tables = attributes.map(&:plural_name)
            @migration_template = 'drop_join_table_migration.rb'
            set_index_names
          when /^drop_(.+)/
            @table_name = normalize_table_name Regexp.last_match(1)
            @migration_template = 'drop_table_migration.rb'
          when /^rename_(.+)_to_(.+)_in_(.+)/
            @old_column_name = Regexp.last_match(1)
            @new_column_name = Regexp.last_match(2)
            @table_name = normalize_table_name Regexp.last_match(3)
            @migration_template = 'rename_column_migration.rb'
          when /^rename_(.+)_to_(.+)/
            @old_table_name = normalize_table_name Regexp.last_match(1)
            @new_table_name = normalize_table_name Regexp.last_match(2)
            @migration_template = 'rename_table_migration.rb'
          when /^change_(.+)_column_(.*)_in_(.+)/
            @column_name = Regexp.last_match(1)
            @old_column_type = Regexp.last_match(2)
            @table_name = normalize_table_name Regexp.last_match(3)
            @migration_template = 'change_column_migration.rb'
          when /^change_(.+)_index_in_(.+)/
            @column_name = Regexp.last_match(1)
            @table_name = normalize_table_name Regexp.last_match(2)
            @migration_template = 'change_index_migration.rb'
          else
            super
          end
        end

        def migration_template(source, destination)
          super(templates_path.join(source), destination)
        end

        def configured_migrate_path
          File.join('storage', options[:database], 'migrate') if options[:database]
        end

        def validate_file_name! = file_name
          .concat('_')
          .concat(SecureRandom.uuid.underscore)

        private

        def templates_path = Rails
          .root
          .join('lib/templates/active_record/migration')
      end
    end
  end
end
