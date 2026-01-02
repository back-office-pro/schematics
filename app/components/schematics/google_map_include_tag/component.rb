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
  module GoogleMapIncludeTag
    class Component < ApplicationComponent
      delegate :gcloud_public_api_key, to: '::Configuration', private: true

      def url = ::URI::HTTPS
        .build(host:, path:, query:)
        .to_s

      private

      def host = 'maps.googleapis.com'

      def path = '/maps/api/js'

      def query = {
        key: gcloud_public_api_key,
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
