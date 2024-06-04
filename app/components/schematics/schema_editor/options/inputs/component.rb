# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Inputs
        class Component < ApplicationComponent
          delegate :option_name, to: :option

          option :builder
          option :option
          option :object

          class << self
            def build(builder:, option:, object:)
              module_parent
                .const_get(option.input_type.to_s.camelize)::Component
                .new(builder:, option:, object:)
            end
          end
        end
      end
    end
  end
end
