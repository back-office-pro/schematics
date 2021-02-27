module Schematics
  module Filter
    module Checkbox
      class Component < Filter::Component
        def active?
          value == 'true'
        end
      end
    end
  end
end
