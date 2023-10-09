# frozen_string_literal: true

module Schematics
  module Footer
    class Component < ApplicationComponent
      delegate :entity, to: ::Migration
      delegate :company_name, to: ::Configuration
      delegate :icon, to: :entity
      delegate :year, to: '::Time.current'

      def resource = ::Migration
        .with_string_translations
        .current

      def css_classes = %w[text-decoration-none]
    end
  end
end
