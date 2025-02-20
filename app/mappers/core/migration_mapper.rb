# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  class MigrationMapper < Dry::Transformer::Pipe
    import Dry::Transformer::ArrayTransformations
    import Dry::Transformer::HashTransformations
    import Dry::Transformer::Conditional

    cast_option_value = Schematics::Transformable[:cast_option_value]

    define! do
      deep_symbolize_keys
      rename_keys entities_attributes: :data
      map_values -> { it.values }
      map_values do
        map_array do
          rename_keys attributes_attributes: :attributes
          rename_keys virtuals_attributes: :virtuals
          rename_keys triggers_attributes: :triggers
          rename_keys has_and_belongs_to_many_associations_attributes: :associations
          rename_keys options_attributes: :options
          map_value :options, -> { it.compact_blank }
          guard -> { it.key?(:attributes) } do
            map_value :attributes, -> { it.values }
            map_value :attributes do
              map_array do
                rename_keys options_attributes: :options
                guard -> { it.key?(:options) } do
                  map_value :options, -> { it.transform_values(&cast_option_value.method(:call)) }
                  map_value :options, -> { it.compact_blank }
                end
              end
            end
          end
          guard -> { it.key?(:virtuals) } do
            map_value :virtuals, -> { it.values }
            map_value :virtuals do
              map_array do
                rename_keys options_attributes: :options
                guard -> { it.key?(:options) } do
                  map_value :options, -> { it.transform_values(&cast_option_value.method(:call)) }
                  map_value :options, -> { it.compact_blank }
                end
              end
            end
          end
          guard -> { it.key?(:triggers) } do
            map_value :triggers, -> { it.values }
          end
          guard -> { it.key?(:associations) } do
            map_value :associations, -> { it.values }
            map_value :associations do
              map_array do
                rename_keys options_attributes: :options
                guard -> { it.key?(:options) } do
                  map_value :options, -> { it.transform_values(&cast_option_value.method(:call)) }
                  map_value :options, -> { it.compact_blank }
                end
              end
            end
          end
        end
      end
    end
  end
end
