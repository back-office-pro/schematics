# frozen_string_literal: true

module Schematics
  module Favicon
    class Component < ApplicationComponent
      def url
        return url_for(company_logo) if company_logo.attached?

        asset_path('@fortawesome/fontawesome-free/svgs/solid/rocket.svg')
      end

      private

      def company_logo = Core::Configuration
        .with_attached_company_logo
        .company_logo
    end
  end
end
