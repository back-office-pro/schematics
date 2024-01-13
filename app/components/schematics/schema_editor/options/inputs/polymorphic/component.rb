# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Inputs
        module Polymorphic
          class Component < Inputs::Component
            def field = object
              .dup
              .tap { _1.name = name }
          end
        end
      end
    end
  end
end
