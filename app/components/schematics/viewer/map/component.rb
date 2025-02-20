# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Viewer
    module Map
      class Component < Grid::Component
        def elements = super.excluding(attribute)

        def attribute = entity
          .address_attributes
          .first
      end
    end
  end
end
