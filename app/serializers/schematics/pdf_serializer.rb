# frozen_string_literal: true

module Schematics
  class PdfSerializer
    def initialize(model_name, resource)
      @model_name = model_name
      @resource = resource
    end

    def generate_file
      WickedPdf.new.pdf_from_string(pdf, options)
    end

    private
     
    def controller
      @controller ||= "#{@model_name.pluralize}Controller".constantize
    end

    def pdf
      @pdf ||= controller.render(
        locals: { resource: @resource },
        assigns: { resource: @resource },
        template: 'schematics/application/show.pdf',
        layout: 'layouts/schematics/pdf'
      )
    end

    def options
      @options ||= {
        header: {
          font_size: 8,
          center: @resource,
          right: '[page] / [topage]',
        },
        footer: {
          font_size: 8,
          left: Setting.instance.company_name,
          center: Setting.instance.company_address,
          right: Setting.instance.company_registration_number,
        },
      }
    end
  end
end
