# frozen_string_literal: true

module Rails
  module Override
    module Generators
      module GeneratedAttribute
        def column_name
          schema_attribute&.column_name || super
        end

        def has_index? # rubocop:disable Naming/PredicateName
          (schema_attribute && !virtual? && !token? && !password_digest?) || join_table? || super
        end

        def inject_index_options = [super, inject_index_type, inject_index_where]
          .compact
          .join(', ')

        def name
          schema_attribute&.name || super
        end

        def options_for_migration
          schema_attribute&.migration_options || super
        end

        def plural_name = [super, join_table_column_options]
          .compact
          .join(', ')

        def reference?(*)
          schema_attribute.is_a?(Schematics::Attributes::Association) || super
        end

        def required? = false

        def type
          schema_attribute&.database_type&.to_sym || super
        end

        def valid_type?(*) = true

        private

        def join_table_column_options
          'column_options: { type: :uuid }' if @type == :join_table_second
        end

        def inject_index_type
          "using: :#{schema_attribute.database_index_type}" if schema_attribute
        end

        def inject_index_where
          "where: 'deleted_at IS NULL'" unless join_table? || has_uniq_index? || token?
        end

        def join_table?
          @type.start_with?('join_table')
        end

        def schema_attribute
          @schema_attribute ||= ::Tenant
                                .schema
                                .find_attribute_by_prefixed_name(@type.to_s)
        end
      end
    end
  end
end
