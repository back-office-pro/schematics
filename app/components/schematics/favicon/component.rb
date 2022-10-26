# frozen_string_literal: true

module Schematics
  module Favicon
    class Component < ApplicationComponent
      def url
        return url_for(logo) if logo.attached?

        asset_path('@fortawesome/fontawesome-free/svgs/solid/rocket.svg')
      end

      private

      def logo
        @logo ||= config(:company_logo)
      end
    end
  end
end
