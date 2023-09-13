# frozen_string_literal: true

module Schematics
  module GoogleMap
    class Component < ApplicationComponent
      option :address, reader: false

      def url = ::URI::HTTPS
        .build(host:, path:, query:)
        .to_s

      private

      def query = { q: address, key: api_key, zoom: }.to_param

      def host = 'www.google.com'

      def path = '/maps/embed/v1/place'

      def address = CGI.escape(@address || ' ')

      def api_key = Engine
        .credentials
        .gcloud[:api_key]

      def zoom = 6
    end
  end
end
