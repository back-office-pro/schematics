# frozen_string_literal: true

module OpenAPI
  module Paths
    class BulkArchive < Path
      protected

      def path = "#{root_path}/bulk-actions"

      def http_method = :post

      def summary = super.pluralize

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
        Components::Response.new(code: 200, description: 'Success'),
        Components::Response.bad_request,
        Components::Response.not_authorized,
        Components::Response.forbidden
      ]
    end
  end
end
