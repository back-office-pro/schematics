# frozen_string_literal: true

module Schematics
  module Footer
    class Component < ApplicationComponent
      delegate :domain, to: ::Tenant, private: true
      delegate :current, :current_version, :entity, to: ::SchemaDataset
      delegate :company_name, to: ::Configuration
      delegate :icon, to: :entity
      delegate :year, to: '::Time.current'

      def website_url = "https://www.#{domain}"

      def css_classes = %w[text-decoration-none]

      alias resource current
    end
  end
end
