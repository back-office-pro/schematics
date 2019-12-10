module Schematics
  module Renderers
    module PDF
      class Attachments < Renderer
        def render(pdf, record)
          attachments = record.instance_eval(@renderable.name)
          unless attachments.empty?
            pdf.text "#{@renderable.name.humanize} : "
            pdf.move_down(10)
            attachments.each do |attachment|
              pdf.image attachment.service_url
              pdf.move_down(10)
            end
          end
        end
      end
    end
  end
end
