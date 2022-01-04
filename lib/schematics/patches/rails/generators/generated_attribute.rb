# frozen_string_literal: true

module Schematics
  module Patches
    module Rails
      module Generators
        module GeneratedAttribute
          def name
            schema_attribute&.name || super
          end

          def type
            schema_attribute&.type&.to_sym || super
          end

          def attr_options
            schema_attribute&.options_for_migration || super
          end

          def default
            schema_attribute.try(:default) || super
          end

          def required?
            return schema_attribute.required? if schema_attribute

            super
          end

          def has_uniq_index? # rubocop:disable Naming/PredicateName
            return schema_attribute.unique? if schema_attribute

            super
          end

          def has_index? # rubocop:disable Naming/PredicateName
            !virtual? && !token? && !password_digest?
          end

          def options_for_migration
            super
              .tap { _1[:index] = { where: 'deleted_at IS NULL' } if _1[:foreign_key] }
              .merge(attr_options)
          end

          def inject_index_options
            [
              super,
              'algorithm: :concurrently',
              ("where: 'deleted_at IS NULL'" unless @type.start_with?('join_table'))
            ].compact.join(', ')
          end

          def plural_name
            [super, ('column_options: { type: :uuid }' if @type == :join_table_second)]
              .compact
              .join(', ')
          end

          private

          def schema_attribute
            @schema_attribute ||= Schematics::Schema
                                  .instance
                                  .find_attribute_by_id(@type.to_s)
          end
        end
      end
    end
  end
end
