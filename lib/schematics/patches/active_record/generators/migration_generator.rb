module Schematics
  module Patches
    module ActiveRecord
      module Generators
        module MigrationGenerator
          private

          def set_local_assigns!
            case file_name
            when /^drop_(.+)_table/
              @table_name = normalize_table_name Regexp.last_match(1)
              @migration_template = drop_table_migration_template_path
            else
              super
            end
          end

          def drop_table_migration_template_path
            Schematics::Engine
              .root
              .join('lib', 'templates', 'active_record', 'migration', 'drop_table_migration.rb')
          end
        end
      end
    end
  end
end
