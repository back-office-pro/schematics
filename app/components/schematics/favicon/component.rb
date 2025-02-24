# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Favicon
    class Component < ApplicationComponent
      def path
        return rails_blob_path(company_logo) if company_logo.attached?

        asset_path('schematics/logo.svg')
      end

      def type
        return company_logo.content_type if company_logo.attached?

        'image/svg+xml'
      end

      private

      def company_logo = current_module::Configuration
        .with_attached_company_logo
        .company_logo
    end
  end
end
