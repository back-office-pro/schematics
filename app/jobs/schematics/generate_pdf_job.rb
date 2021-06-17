# frozen_string_literal: true

module Schematics
  class GeneratePdfJob < ApplicationJob
    def perform(model_name, resource_id, filepath)
      resource = model_name.constantize.find(resource_id)
      controller = "#{model_name.pluralize}Controller".constantize
      pdf_html = controller.render(
        locals: { resource: resource },
        assigns: { resource: resource },
        template: 'schematics/application/show.pdf',
        layout: 'layouts/schematics/pdf'
      )
      pdf_options = {
        header: {
          font_size: 8,
          center: resource,
          right: '[page] / [topage]',
        },
        footer: {
          font_size: 8,
          left: Setting.instance.company_name,
          center: Setting.instance.company_address,
          right: Setting.instance.company_registration_number,
        },
      }
      pdf_doc = WickedPdf.new.pdf_from_string(pdf_html, pdf_options)
      File.open(filepath, 'wb') { |file| file << pdf_doc }
    end
  end
end
