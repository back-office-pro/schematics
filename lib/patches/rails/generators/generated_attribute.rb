# frozen_string_literal: true

module Patches
  module Rails
    module Generators
      module GeneratedAttribute
        def column_name
          schema_attribute&.column_name || super
        end

        def has_index? # rubocop:disable Naming/PredicateName
          !virtual? && !token? && !password_digest?
        end

        def has_uniq_index? # rubocop:disable Naming/PredicateName
          return schema_attribute.unique? if schema_attribute

          super
        end

        def inject_index_options = [
          super,
          'algorithm: :concurrently',
          ("using: :#{schema_attribute.database_index_type}" if schema_attribute),
          ("where: 'deleted_at IS NULL'" unless @type.start_with?('join_table'))
        ].compact.join(', ')

        def name
          schema_attribute&.name || super
        end

        def options_for_migration
          schema_attribute&.migration_options || super
        end

        def plural_name = [
          super,
          ('column_options: { type: :uuid }' if @type == :join_table_second)
        ].compact.join(', ')

        def reference?(*)
          schema_attribute.is_a?(Schematics::Attributes::Association) || super
        end

        def required? = false

        def type
          schema_attribute&.database_type&.to_sym || super
        end

        def valid_type?(*) = true

        private

        def schema_attribute
          @schema_attribute ||= Tenant
                                .current
                                .schema
                                .find_attribute_by_prefixed_name(@type.to_s)
        end
      end
    end
  end
end
