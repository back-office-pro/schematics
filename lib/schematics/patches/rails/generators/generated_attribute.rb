# frozen_string_literal: true

require 'schematics/schema'

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
            return schema_attribute.try(:default) if schema_attribute

            super
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
            super.merge(attr_options)
          end

          def plural_name
            return "#{super}, column_options: { type: :uuid }" if @type == :join_table_uuid

            super
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
