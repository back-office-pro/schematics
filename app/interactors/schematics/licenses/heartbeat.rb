# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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

      def url = website_url(path: '/license_heartbeat')

      def request_method = 'POST'

      def secret_key = [Socket.gethostname, MacAddress.address].join('|')
    end
  end
end
