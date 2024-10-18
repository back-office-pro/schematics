# frozen_string_literal: true

module Schematics
  module GoogleMapIncludeTag
    class Component < ApplicationComponent
      delegate :gcloud_api_key_with_fallback, to: ::Configuration, private: true

      def url = ::URI::HTTPS
        .build(host:, path:, query:)
        .to_s

      private

      def query = { key: gcloud_api_key_with_fallback, loading:, libraries:, callback: }.to_param

      def host = 'maps.googleapis.com'

      def path = '/maps/api/js'

      def libraries = 'places'

      def loading = 'async'

      def callback = 'Function.prototype'
    end
  end
end
