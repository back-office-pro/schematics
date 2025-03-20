# Copyright © 2025 Dev & Software. All rights reserved.
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
