# frozen_string_literal: true

module Schematics
  class PdfSerializer
    delegate :render, to: :controller, private: true
    delegate :human_name, to: :model_class, private: true

    def initialize(resource)
      @resource = resource
    end

    def content
      Grover.new(pdf, options).to_pdf
    end

    def file
      @file ||= begin
        file = Tempfile.new
        file.binmode
        file.write(content)
        file.rewind
        file
      end
    end

    def filename
      "#{human_name.dasherize}-#{@resource.slug}.pdf"
    end

    private

    def model_class
      @resource.class
    end

    def controller
      @controller ||= "#{model_class.to_s.pluralize}Controller".constantize
    end

    def pdf
      @pdf ||= Grover::HTMLPreprocessor.process(template, asset_url.to_s, asset_url.scheme)
    end

    def template
      @template ||= render(
        action: :show,
        formats: :pdf,
        layout: 'layouts/schematics/pdf',
        locals: { resource: @resource },
        assigns: { resource: @resource }
      )
    end

    def options
      {
        header_template: PdfHeader::Component.new(resource: @resource).to_html,
        footer_template: PdfFooter::Component.new.to_html
      }
    end

    def asset_url
      @asset_url ||= URI.parse(
        URI::HTTP
          .build(**Rails.application.routes.default_url_options.merge(path: '/'))
          .to_s
      )
    end
  end
end
