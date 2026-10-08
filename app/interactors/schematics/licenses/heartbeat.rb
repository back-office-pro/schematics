# frozen_string_literal: true

module Schematics
  module Licenses
    class Heartbeat < ::Core::WebhookRequests::Request
      delegate :website_url, to: 'Rails.application.routes.url_helpers', private: true

      def call
        return unless response in Net::HTTPUnauthorized

        ::Configuration.instance.license_file.purge
        Rails.cache.delete('configuration/license_file')
      end

      private

      def body = ::Configuration
        .license
        .as_json

      def url = website_url(path: '/license/heartbeat')

      def request_method = 'POST'

      def secret_key = [Socket.gethostname, MacAddress.address].join('|')
    end
  end
end
