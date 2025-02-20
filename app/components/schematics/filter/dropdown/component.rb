# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Filter
    module Dropdown
      class Component < Filter::Component
        delegate :collection, to: :field

        def data
          super.merge(controller: 'dropdown')
        end
      end
    end
  end
end
