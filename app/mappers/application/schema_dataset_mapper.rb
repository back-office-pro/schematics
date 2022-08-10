# frozen_string_literal: true

require 'dry/transformer/conditional'

module Application
  class SchemaDatasetMapper < Dry::Transformer::Pipe
    import Dry::Transformer::ArrayTransformations
    import Dry::Transformer::HashTransformations
    import Dry::Transformer::Conditional

    # rubocop:disable Metrics/BlockLength
    define! do
      deep_symbolize_keys
      rename_keys entities_attributes: :data
      map_values -> { _1.values }
      map_values do
        map_array do
          rename_keys attributes_attributes: :attributes
          rename_keys virtuals_attributes: :virtuals
          rename_keys triggers_attributes: :triggers
          rename_keys options_attributes: :options
          map_value :options, -> { _1.compact_blank }
          map_value :attributes, -> { _1.values }
          map_value :attributes do
            map_array do
              rename_keys options_attributes: :options
              guard -> { _1.key?(:options) } do
                map_value :options, lambda { |options|
                  options.transform_values do |value|
                    case value
                    in 'true'
                      true
                    in 'false'
                      false
                    in /^(\d)+$/
                      value.to_i
                    in /^(\d)+\.(\d)+$/
                      value.to_f
                    else
                      value
                    end
                  end
                }
                map_value :options, -> { _1.compact_blank }
              end
            end
          end
          guard -> { _1.key?(:virtuals) } do
            map_value :virtuals, -> { _1.values }
            map_value :virtuals do
              map_array do
                rename_keys options_attributes: :options
                guard -> { _1.key?(:options) } do
                  map_value :options, lambda { |options|
                    options.transform_values do |value|
                      case value
                      in 'true'
                        true
                      in 'false'
                        false
                      in /^(\d)+$/
                        value.to_i
                      in /^(\d)+\.(\d)+$/
                        value.to_f
                      else
                        value
                      end
                    end
                  }
                  map_value :options, -> { _1.compact_blank }
                end
              end
            end
          end
          guard -> { _1.key?(:triggers) } do
            map_value :triggers, -> { _1.values }
          end
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
