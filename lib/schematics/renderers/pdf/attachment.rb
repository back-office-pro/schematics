module Schematics
  module Renderers
    module PDF
      class Attachment < Renderer
        def render(pdf, record)
          attachment = Array(record.instance_eval(@renderable.name))
          unless attachment.blank?
            pdf.text "#{@renderable.name.humanize} : "
            pdf.move_down(10)
            pdf.image attachment.service_url
            pdf.move_down(10)
          end
        end
      end
    end
  end
end
