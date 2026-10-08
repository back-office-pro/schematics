# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Inputs
        module Select
          class Component < Inputs::Component
            delegate :controller, :multiple?, :collection, to: :option

            def data = { controller: }

            def selected = object.try(option_name)
          end
        end
      end
    end
  end
end
