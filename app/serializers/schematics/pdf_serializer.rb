# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  class PDFSerializer
    delegate :render, to: :renderer, private: true
    delegate :human_name, :route_params, to: :model_class, private: true
    delegate :default_url_options, to: ::Configuration, private: true
    delegate :key_generator, :config, to: '::Rails.application', private: true
    delegate :assume_ssl, to: :config, private: true

    def initialize(resource)
      @resource = resource
      @template = ::PDFTemplate.find_by(model: model_name)
    end

    memoize def content
      page = browser.create_page
      page.content = template.gsub(%r{/assets/}, assets_url)
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

    def filename = "#{human_name.parameterize}-#{@resource.to_param}.#{extension}"

    private

    def model_name
      model_class.to_s
    end

    def model_class
      @resource.class
    end

    def assets_url = URI
      .const_get(assume_ssl ? :HTTPS : :HTTP)
      .build(**default_url_options, path: '/assets/')
      .to_s

    def controller_name = "::#{model_name.pluralize}Controller"

    def controller_class
      controller_name.safe_constantize || ResourcesController
    end

    def renderer = controller_class
      .renderer
      .new(**renderer_options)

    def renderer_options = ::Rails
      .configuration
      .action_dispatch
      .merge(key_generator:)
      .merge('request.parameters': route_params)
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
