# Copyright © 2025 Dev & Software. All rights reserved.
#
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
    class Heartbeat
      include Interactable

      delegate :website_url, to: 'Rails.application.routes.url_helpers', private: true
      delegate :email, :signature, to: '::Configuration.license', private: true

      def call = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      private

      def uri
        URI website_url(path: '/license_hearbeat')
      end

      def request = Net::HTTP::Post
        .new(uri)
        .tap { _1.form_data = payload.to_json }

      def payload = { email:, signature:, fingerprint: }

      def fingerprint = [`hostname`, MacAddress.address].join('|')
    end
  end
end
