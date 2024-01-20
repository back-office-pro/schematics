# frozen_string_literal: true

module Schematics
  class PdfSerializer
    delegate :render, to: :renderer, private: true
    delegate :human_name, to: :model_class, private: true
    delegate :default_url_options, to: ::Tenant, private: true
    delegate :key_generator, to: '::Rails.application', private: true
    delegate :cookies_rotations,
             :signed_cookie_salt,
             :encrypted_cookie_salt,
             :encrypted_signed_cookie_salt,
             :authenticated_encrypted_cookie_salt,
             :use_authenticated_cookie_encryption,
             to: '::Rails.configuration.action_dispatch', private: true

    def initialize(resource)
      @resource = resource
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

    def assets_url = URI::HTTP
      .build(**default_url_options)
      .to_s

    def renderer = "#{model_class.to_s.pluralize}Controller"
      .constantize
      .renderer
      .new(**action_dispatch_options)

    def model_class
      @resource.class
    end

    def action_dispatch_options = {
      'action_dispatch.key_generator': key_generator,
      'action_dispatch.cookies_rotations': cookies_rotations,
      'action_dispatch.signed_cookie_salt': signed_cookie_salt,
      'action_dispatch.encrypted_cookie_salt': encrypted_cookie_salt,
      'action_dispatch.encrypted_signed_cookie_salt': encrypted_signed_cookie_salt,
      'action_dispatch.authenticated_encrypted_cookie_salt': authenticated_encrypted_cookie_salt,
      'action_dispatch.use_authenticated_cookie_encryption': use_authenticated_cookie_encryption
    }

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

    memoize def browser = Ferrum::Browser.new(browser_options:, timeout: 5)

    def browser_options = { 'no-sandbox': nil, 'disable-setuid-sandbox': nil }

    memoize def template = render(
      action: :show,
      formats: :pdf,
      layout: 'layouts/schematics/pdf',
      locals: { resource: @resource },
      assigns: { resource: @resource }
    )
  end
end
