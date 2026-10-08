# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Inputs
        module Number
          class Component < Inputs::Component
            delegate :min, to: :option
          end
        end
      end
    end
  end
end
