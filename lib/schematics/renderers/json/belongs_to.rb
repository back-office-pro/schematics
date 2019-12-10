module Schematics
  module Renderers
    module JSON 
      class BelongsTo < Renderer
        def render(descriptor)
          [@renderable.name.to_sym, { only: [:id, descriptor.name.to_sym], methods: [descriptor.name.to_sym] }]
        end
      end
    end
  end
end
