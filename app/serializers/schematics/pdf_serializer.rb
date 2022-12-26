# frozen_string_literal: true

module Schematics
  class PdfSerializer
    PROTOCOL_REGEX = %r{(href|src)=(['"])//([^"']*|[^"']*)['"]}
    PATH_REGEX = %r{(href|src)=(['"])/([^/"']([^"']*|[^"']*))?['"]}

    delegate :render, to: :controller, private: true
    delegate :human_name, to: :model_class, private: true
    delegate :default_url_options, to: '::Tenant', private: true

    def initialize(resource)
      @resource = resource
    end

    def content
      browser.go_to("data:text/html,#{template_with_absolute_paths}")
      browser.pdf(**pdf_options)
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

    def asset_url
      URI.parse(URI::HTTP.build(**default_url_options.merge(path: '/')).to_s)
    end

    def controller
      @controller ||= "#{model_class.to_s.pluralize}Controller".constantize
    end

    def model_class
      @resource.class
    end

    def pdf_options = {
      header_template: PdfHeader::Component.new(resource: @resource).to_html,
      footer_template: PdfFooter::Component.new.to_html,
      margin: { top: 48, bottom: 48, left: 16, right: 16 },
      display_header_footer: true,
      cache: false,
      format: :A4,
      encoding: :binary
    }

    def browser
      @browser ||= Ferrum::Browser.new(browser_options:)
    end

    def browser_options = { 'no-sandbox': nil, 'disable-setuid-sandbox': nil }

    def template_with_absolute_paths = template
      .gsub(PATH_REGEX, "\\1=\\2#{asset_url}\\3\\2")
      .gsub(PROTOCOL_REGEX, "\\1=\\2#{asset_url.scheme}://\\3\\2")

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
