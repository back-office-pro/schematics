# frozen_string_literal: true

module Schematics
  module GoogleMapIncludeTag
    class Component < ApplicationComponent
      def url = ::URI::HTTPS
        .build(host:, path:, query:)
        .to_s

      private

      def query = { key: api_key, libraries: 'places', callback: 'Function.prototype' }.to_param

      def host = 'maps.googleapis.com'

      def path = '/maps/api/js'

      def api_key = Engine
        .credentials
        .gcloud[:api_key]
    end
  end
end
