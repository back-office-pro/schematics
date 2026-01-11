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
    class Heartbeat
      include Interactable

      TIMEOUT_OPTIONS = {
        open_timeout: 5,
        read_timeout: 5,
        write_timeout: 5,
        max_retries: 0
      }.freeze

      delegate :website_url, to: 'Rails.application.routes.url_helpers', private: true
      delegate :license, to: '::Configuration', private: true
      delegate :start, to: 'Net::HTTP', private: true

      def call = start(uri.hostname, uri.port, **TIMEOUT_OPTIONS, use_ssl: true) do |http|
        http.request(request)
      end

      private

      def uri = URI(website_url(path: '/license_heartbeat'))

      def request = Net::HTTP::Post
        .new(uri)
        .tap { _1.form_data = license.as_json }
    end
  end
end
