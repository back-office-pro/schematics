module Schematics
  module Renderers
    module PDF
      class BelongsTo < Renderer
        def render(pdf, record, descriptor)
          value = record.instance_eval("#{@renderable.name}.#{descriptor.name}")
          unless value.nil?
            pdf.text "#{@renderable.name.humanize} : #{format(value)}"
            pdf.move_down(10)
          end
        end
      end
    end
  end
end
