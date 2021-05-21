# frozen_string_literal: true

module Schematics
  module Filter
    module Dropdown
      class Component < Filter::Component
        def collection
          @field.input_collection.map(&:reverse)
        end
      end
    end
  end
end
