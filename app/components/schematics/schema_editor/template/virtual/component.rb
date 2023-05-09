# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Template
      module Virtual
        class Component < Template::Component
          def virtual = Virtuals::Calculation.new(entity:)
        end
      end
    end
  end
end
