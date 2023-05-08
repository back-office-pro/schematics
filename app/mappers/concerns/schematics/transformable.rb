# frozen_string_literal: true

module Schematics
  module Transformable
    extend Dry::Transformer::Registry

    module_function

    def cast_option_value(value)
      case value
      in 'true'
        true
      in 'false'
        false
      in /^(\d)+$/
        value.to_i
      in /^(\d)+\.(\d)+$/
        value.to_f
      in Hash
        value.values
      else
        value
      end
    end
  end
end
