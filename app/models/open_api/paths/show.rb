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

module OpenAPI
  module Paths
    class Show < Path
      protected

      def path
        return root_path if singleton?

        "#{root_path}/{id}"
      end

      def http_method = :get

      def parameters = super.push(
        (Components::Parameter.id unless singleton?)
      )

      def responses = [
        Components::Response.not_authorized,
        Components::Response.forbidden,
        Components::Response.not_found,
        Components::Response.success(code: 200, data: open_api_schema_with_associations)
      ]
    end
  end
end
