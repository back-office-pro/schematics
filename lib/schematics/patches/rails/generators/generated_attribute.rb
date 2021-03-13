require 'schematics/schema'

module Schematics
  module Patches
    module Rails
      module Generators
        module GeneratedAttribute
          OPTIONS_WHITELIST = %i[limit precision scale default polymorphic].freeze

          def name
            schema_attribute&.name || super
          end

          def type
            schema_attribute&.type&.to_sym || super
          end

          def default
            attr_options[:default] || schema_attribute.try(:default) || super
          end

          def required?
            schema_attribute&.required? || super
          end

          def attr_options
            schema_attribute&.options&.slice(*OPTIONS_WHITELIST) || super
          end

          def has_uniq_index? # rubocop:disable Naming/PredicateName
            schema_attribute&.unique? || super
          end

          def has_index? # rubocop:disable Naming/PredicateName
            !virtual? && !token? && !password_digest?
          end

          def options_for_migration
            return super if schema_attribute.nil?
            options = super.merge(attr_options)
            foreign_key_type = schema_attribute.options[:type]
            if options.key?(:foreign_key) && foreign_key_type.present?
              options[:foreign_key] = { to_table: foreign_key_type.pluralize.to_sym }
            end
            options
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
