# frozen_string_literal: true

module Schematics
  module Favicon
    class Component < ApplicationComponent
      delegate :company_logo, to: ::Configuration, private: true

      def url
        return url_for(company_logo) if company_logo.attached?

        asset_path('@fortawesome/fontawesome-free/svgs/solid/rocket.svg')
      end
    end
  end
end
