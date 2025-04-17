# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module GoogleMapIncludeTag
    class Component < ApplicationComponent
      delegate :gcloud_public_api_key_with_fallback, to: '::Configuration', private: true

      def url = ::URI::HTTPS
        .build(host:, path:, query:)
        .to_s

      private

      def host = 'maps.googleapis.com'

      def path = '/maps/api/js'

      def query = {
        key: gcloud_public_api_key_with_fallback,
        loading:,
        libraries:,
        callback:
      }.to_param

      def loading = 'async'

      def libraries = 'places'

      def callback = 'Function.prototype'
    end
  end
end
