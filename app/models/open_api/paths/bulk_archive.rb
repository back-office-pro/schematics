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
    class BulkArchive < Path
      protected

      alias summary_slug tag

      def path = File.join(root_path, translate('routes.bulk_actions'))

      def http_method = :post

      def request_body = {
        required: false,
        description: '',
        content: {
          'multipart/form-data': {
            schema: {
              type: 'object',
              properties: {
                'bulk_action[ids]': {
                  type: 'array',
                  items: {
                    type: 'string'
                  },
                  required: true
                }
              }
            }
          },
          'application/json': {
            schema: {
              type: 'object',
              properties: {
                bulk_action: {
                  type: 'object',
                  properties: {
                    ids: {
                      type: 'array',
                      items: {
                        type: 'string'
                      }
                    }
                  },
                  required: %w[ids]
                }
              }
            }
          }
        }
      }

      def responses = [
        Components::Response.success(code: 200),
        Components::Response.bad_request,
        Components::Response.not_authorized,
        Components::Response.forbidden
      ]
    end
  end
end
