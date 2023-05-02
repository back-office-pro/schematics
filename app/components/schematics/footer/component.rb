# frozen_string_literal: true

module Schematics
  module Footer
    class Component < ApplicationComponent
      delegate :domain, to: ::Tenant, private: true
      delegate :current_version, :entity, to: Core::SchemaDataset
      delegate :company_name, to: Core::Configuration
      delegate :icon, to: :entity
      delegate :year, to: '::Time.current'

      def website_url = "https://www.#{domain}"
    end
  end
end
