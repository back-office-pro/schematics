# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
      map_values -> { _1.values }
      map_values do
        map_array do
          rename_keys attributes_attributes: :attributes
          rename_keys virtuals_attributes: :virtuals
          rename_keys triggers_attributes: :triggers
          rename_keys has_and_belongs_to_many_associations_attributes: :associations
          rename_keys options_attributes: :options
          map_value :options, -> { _1.compact_blank }
          guard -> { _1.key?(:attributes) } do
            map_value :attributes, -> { _1.values }
            map_value :attributes do
              map_array do
                rename_keys options_attributes: :options
                guard -> { _1.key?(:options) } do
                  map_value :options, -> { _1.transform_values(&cast_option_value.method(:call)) }
                  map_value :options, -> { _1.compact_blank }
                end
              end
            end
          end
          guard -> { _1.key?(:virtuals) } do
            map_value :virtuals, -> { _1.values }
            map_value :virtuals do
              map_array do
                rename_keys options_attributes: :options
                guard -> { _1.key?(:options) } do
                  map_value :options, -> { _1.transform_values(&cast_option_value.method(:call)) }
                  map_value :options, -> { _1.compact_blank }
                end
              end
            end
          end
          guard -> { _1.key?(:triggers) } do
            map_value :triggers, -> { _1.values }
          end
          guard -> { _1.key?(:associations) } do
            map_value :associations, -> { _1.values }
            map_value :associations do
              map_array do
                rename_keys options_attributes: :options
                guard -> { _1.key?(:options) } do
                  map_value :options, -> { _1.transform_values(&cast_option_value.method(:call)) }
                  map_value :options, -> { _1.compact_blank }
                end
              end
            end
          end
        end
      end
    end
  end
end
