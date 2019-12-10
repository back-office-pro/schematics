module Schematics
  module Renderers
    module PDF
      class Default < Renderer
        def render(pdf, record)
          value = record.instance_eval(@renderable.name)
          unless value.nil?
            pdf.text "#{@renderable.name.humanize} : #{format(value)}"
            pdf.move_down(10)
          end
        end
      end
    end
  end
end
