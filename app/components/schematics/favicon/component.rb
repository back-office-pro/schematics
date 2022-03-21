# frozen_string_literal: true

module Schematics
  module Favicon
    class Component < ApplicationComponent
      delegate :settings, to: :helpers

      def url
        return url_for(settings(:company_logo)) if settings(:company_logo).attached?

        asset_path('fa5/solid/rocket.svg')
      end
    end
  end
end
