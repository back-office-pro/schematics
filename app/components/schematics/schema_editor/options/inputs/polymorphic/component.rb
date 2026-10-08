# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Inputs
        module Polymorphic
          class Component < Inputs::Component
            def field = object
              .dup
              .tap { it.name = option_name }
              .tap { it.options.delete(:required) }
          end
        end
      end
    end
  end
end
