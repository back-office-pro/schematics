module Schematics
  module Renderers
    module CSV
      class BelongsTo < Renderer
        def render(record, descriptor)
          format(record.instance_eval("#{@renderable.name}.#{descriptor.name}"))
        end
      end
    end
  end
end
