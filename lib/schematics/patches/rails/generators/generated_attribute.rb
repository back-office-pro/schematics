# frozen_string_literal: true

module Schematics
  module Patches
    module Rails
      module Generators
        module GeneratedAttribute
          def attr_options
            schema_attribute&.options_for_migration || super
          end

          # :reek:NilCheck
          def default
            case attribute_default = schema_attribute.try(:default)
            when ::String
              attribute_default.to_json
            when nil
              super
            else
              attribute_default
            end
          end

          def has_index? # rubocop:disable Naming/PredicateName
            !virtual? && !token? && !password_digest?
          end

          def has_uniq_index? # rubocop:disable Naming/PredicateName
            return false if token?
            return schema_attribute.unique? if schema_attribute

            super
          end

          def inject_index_options = [
            super,
            'algorithm: :concurrently',
            ("where: 'deleted_at IS NULL'" unless @type.start_with?('join_table'))
          ].compact.join(', ')

          def name
            schema_attribute&.name || super
          end

          def options_for_migration = super
            .tap { _1[:index] = { where: 'deleted_at IS NULL' } if _1[:foreign_key] }
            .merge(attr_options)

          def plural_name = [
            super,
            ('column_options: { type: :uuid }' if @type == :join_table_second)
          ].compact.join(', ')

          def required?
            return schema_attribute.required? if schema_attribute

            super
          end

          def type
            schema_attribute&.database_type&.to_sym || super
          end

          def valid_type?(*) = true

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
