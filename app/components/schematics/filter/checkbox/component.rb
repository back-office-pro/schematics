# frozen_string_literal: true

module Schematics
  module Filter
    module Checkbox
      class Component < Filter::Component
        def active?
          value == 'true'
        end

        def display_label?
          @field == :with_deleted
        end
      end
    end
  end
end
