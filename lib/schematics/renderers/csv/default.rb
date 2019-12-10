module Schematics
  module Renderers
    module CSV
      class Default < Renderer
        def render(record)
          format(record.instance_eval(@renderable.name))
        end
      end
    end
  end
end
