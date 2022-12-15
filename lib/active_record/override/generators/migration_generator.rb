# frozen_string_literal: true

module ActiveRecord
  module Override
    module Generators
      module MigrationGenerator
        def set_local_assigns!
          case file_name
          when /^drop_join_table_(.+)/
            @join_tables = attributes.map(&:plural_name)
            @migration_template = drop_join_table_migration_template_path
            set_index_names
          when /^drop_(.+)/
            @table_name = normalize_table_name Regexp.last_match(1)
            @migration_template = drop_table_migration_template_path
          when /^rename_(.+)_to_(.+)_in_(.+)/
            @old_column_name = Regexp.last_match(1)
            @new_column_name = Regexp.last_match(2)
            @table_name = normalize_table_name Regexp.last_match(3)
            @migration_template = rename_column_migration_template_path
          when /^rename_(.+)_to_(.+)/
            @old_table_name = normalize_table_name Regexp.last_match(1)
            @new_table_name = normalize_table_name Regexp.last_match(2)
            @migration_template = rename_table_migration_template_path
          when /^change_(.+)_in_(.+)/
            @column_name = Regexp.last_match(1)
            @table_name = normalize_table_name Regexp.last_match(2)
            @migration_template = change_column_migration_template_path
          else
            super
          end
        end

        private

        def change_column_migration_template_path
          templates_path.join('change_column_migration.rb')
        end

        def drop_join_table_migration_template_path
          templates_path.join('drop_join_table_migration.rb')
        end

        def drop_table_migration_template_path
          templates_path.join('drop_table_migration.rb')
        end

        def rename_column_migration_template_path
          templates_path.join('rename_column_migration.rb')
        end

        def rename_table_migration_template_path
          templates_path.join('rename_table_migration.rb')
        end

        def templates_path
          Schematics::Engine.root.join('lib', 'templates', 'active_record', 'migration')
        end
      end
    end
  end
end
