# frozen_string_literal: true

module Schematics
  module GoogleMap
    class Component < ApplicationComponent
      delegate :gcloud_public_api_key, to: '::Configuration'
      option :address

      def url = ::URI::HTTPS
        .build(host:, path:, query:)
        .to_s

      private

      def host = 'www.google.com'

      def path = '/maps/embed/v1/place'

      def query = { q: address, key: gcloud_public_api_key, zoom: }.to_param

      def address = CGI.escape(super || ' ')

      def zoom = 6
    end
  end
end
