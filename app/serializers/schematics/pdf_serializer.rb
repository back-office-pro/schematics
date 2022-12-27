# frozen_string_literal: true

module Schematics
  class PdfSerializer
    delegate :render, to: :controller, private: true
    delegate :human_name, to: :model_class, private: true
    delegate :default_url_options, to: '::Tenant', private: true

    def initialize(resource)
      @resource = resource
    end

    def content
      page = browser.create_page
      page.content = template.gsub(%r{/assets/}, "#{assets_url}/assets/")
      page.network.wait_for_idle
      page.pdf(**pdf_options)
    ensure
      browser.quit
    end

    def content_type = ::Mime[extension].to_s

    def extension = :pdf

    def file
      @file ||= begin
        file = Tempfile.new
        file.binmode
        file.write(content)
        file.rewind
        file
      end
    end

    def filename = "#{human_name.dasherize}-#{@resource.slug}.#{extension}"

    private

    def assets_url = URI::HTTP
      .build(**default_url_options)
      .to_s

    def controller
      @controller ||= "#{model_class.to_s.pluralize}Controller".constantize
    end

    def model_class
      @resource.class
    end

    def pdf_options = {
      header_template: PdfHeader::Component.new(resource: @resource).to_html,
      footer_template: PdfFooter::Component.new.to_html,
      display_header_footer: true,
      margin_top: 0.5,
      margin_bottom: 0.5,
      margin_left: 0.167,
      margin_right: 0.167,
      encoding: :binary,
      cache: false,
      format: :A4
    }

    def browser
      @browser ||= Ferrum::Browser.new(browser_options:)
    end

    def browser_options = { 'no-sandbox': nil, 'disable-setuid-sandbox': nil }

    def template
      @template ||= render(
        action: :show,
        formats: :pdf,
        layout: 'layouts/schematics/pdf',
        locals: { resource: @resource },
        assigns: { resource: @resource }
      )
    end
  end
end
