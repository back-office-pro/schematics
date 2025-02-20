# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  class OpenAiMapper < Dry::Transformer::Pipe
    import Dry::Transformer::ArrayTransformations
    import Dry::Transformer::HashTransformations
    import Dry::Transformer::Conditional

    define! do
      deep_symbolize_keys
      accept_keys :choices
      rename_keys choices: :data
      map_values { extract_key :message }
      map_values { extract_key :tool_calls }
      map_values -> { it.flatten }
      map_values { extract_key :function }
      map_values { extract_key :arguments }
      map_values { map_array -> { JSON.parse(it) } }
      deep_symbolize_keys
      map_values do
        map_array -> { it.merge(id: SecureRandom.uuid) }
      end
      map_values do
        map_array do
          map_value :attributes do
            map_array -> { it.merge(id: SecureRandom.uuid) }
            map_array do
              guard -> { it.key?(:options) } do
                map_value :options, -> { it.compact_blank }
                map_value :options do
                  guard -> { it.key?(:events) } do
                    map_value :events do
                      map_array -> { it.merge(id: SecureRandom.uuid) }
                    end
                  end
                end
              end
            end
            map_array -> { it.compact_blank }
          end
        end
      end
    end
  end
end
