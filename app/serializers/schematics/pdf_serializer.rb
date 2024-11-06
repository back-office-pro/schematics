# frozen_string_literal: true

module Schematics
  class PDFSerializer
    delegate :render, to: :renderer, private: true
    delegate :human_name, to: :model_class, private: true
    delegate :default_url_options, :ssl?, to: ::Tenant, private: true
    delegate :key_generator, to: '::Rails.application', private: true

    def initialize(resource)
      @resource = resource
      @template = ::PDFTemplate.find_by(model: model_class.to_s)
    end

    memoize def content
      page = browser.create_page
      page.content = template.gsub(%r{/assets/}, "#{assets_url}/assets/")
      page.network.wait_for_idle(timeout: 30)
      page.pdf(**pdf_options)
    ensure
      browser.quit
    end

    def content_type = ::Mime[extension].to_s

    def extension = :pdf

    memoize def file = Tempfile
      .new
      .tap(&:binmode)
      .tap { _1.write(content) }
      .tap(&:rewind)

    def filename = "#{human_name.dasherize}-#{@resource.to_param}.#{extension}"

    private

    def assets_url = URI
      .const_get(ssl? ? :HTTPS : :HTTP)
      .build(**default_url_options)
      .to_s

    def renderer = "#{model_class.to_s.pluralize}Controller"
      .constantize
      .renderer
      .new(**renderer_options)

    def model_class
      @resource.class
    end

    def renderer_options = ::Rails
      .configuration
      .action_dispatch
      .merge(key_generator:)
      .transform_keys { "action_dispatch.#{_1}" }

    def pdf_options = {
      header_template: PDFHeader::Component.new(resource: @resource).to_html,
      footer_template: PDFFooter::Component.new.to_html,
      display_header_footer: true,
      margin_top: 0.5,
      margin_bottom: 0.5,
      margin_left: 0.167,
      margin_right: 0.167,
      encoding: :binary,
      cache: false,
      format: :A4
    }

    memoize def browser = Ferrum::Browser.new(
      url: ENV.fetch('CHROME_URL', nil),
      browser_options:,
      timeout: 30,
      process_timeout: 30
    )

    def browser_options = { 'no-sandbox': nil, 'disable-setuid-sandbox': nil }

    memoize def template
      if @template
        render(
          TemplateInterpolation::Component.new(template: @template, resource: @resource),
          layout: 'layouts/schematics/pdf',
          formats: :pdf
        )
      else
        render(
          action: :show,
          formats: :pdf,
          layout: 'layouts/schematics/pdf',
          locals: { resource: @resource },
          assigns: { resource: @resource }
        )
      end
    end
  end
end
