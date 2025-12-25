# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Licenses
    class Heartbeat
      include Interactable

      delegate :website_url, to: 'Rails.application.routes.url_helpers', private: true

      def call = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      private

      def uri
        URI website_url(path: 'license')
      end

      def request = Net::HTTP::Post
        .new(uri)
        .tap { _1.form_data = payload }

      def payload = {
        signature: ::Configuration.license.signature,
        fingerprint: MacAddress.address
      }
    end
  end
end
