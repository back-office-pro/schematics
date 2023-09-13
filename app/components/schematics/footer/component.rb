# frozen_string_literal: true

module Schematics
  module Footer
    class Component < ApplicationComponent
      delegate :domain, to: ::Tenant, private: true
      delegate :entity, to: ::Migration
      delegate :company_name, to: ::Configuration
      delegate :icon, to: :entity
      delegate :year, to: '::Time.current'

      def resource = ::Migration
        .with_string_translations
        .current

      def website_url = ::URI::HTTPS
        .build(host: "www.#{domain}")
        .to_s

      def css_classes = %w[text-decoration-none]
    end
  end
end
