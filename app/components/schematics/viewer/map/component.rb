# frozen_string_literal: true

module Schematics
  module Viewer
    module Map
      class Component < Grid::Component
        def elements = super.grep_v(Attributes::Address)

        def address = resource.public_send(entity.address_attributes.first.name)
      end
    end
  end
end
