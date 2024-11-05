# frozen_string_literal: true

module Rails
  module Override
    module Generators
      module GeneratedAttribute
        def column_name
          schema_attribute&.column_name || super
        end

        def has_index? # rubocop:disable Naming/PredicateName
          (schema_attribute in Schematics::Behaviours::Indexable) || has_uniq_index? || super
        end

        def has_uniq_index? # rubocop:disable Naming/PredicateName
          return schema_attribute.unique? if schema_attribute

          super
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

        def reference?(*)
          (schema_attribute in Schematics::Attributes::Association) || super
        end

        def required? = false

        def type
          schema_attribute&.database_type&.to_sym || super
        end

        def valid_type?(*) = true

        private

        def schema_attribute
          @schema_attribute ||= ::Tenant
                                .schema
                                .find_attribute_by_prefixed_name(@type.to_s)
        end

        def inject_index_type
          "using: :#{schema_attribute.database_index_type}" if schema_attribute
        end

        def inject_index_where
          "where: 'deleted_at IS NULL'" unless index_name in Array
        end
      end
    end
  end
end
