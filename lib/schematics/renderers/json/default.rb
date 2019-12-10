module Schematics
  module Renderers
    module JSON 
      class Default < Renderer
        def render
          @renderable.name.to_sym
        end
      end
    end
  end
end
