require 'schematics/graphics/axes/axis'

module Schematics
  module Graphics
    module Axes
      class X < Axis
        def title
          super.join(' ').singularize
        end
      end
    end
  end
end
