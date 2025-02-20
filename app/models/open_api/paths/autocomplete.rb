# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module OpenAPI
  module Paths
    class Autocomplete < Path
      protected

      alias summary_slug tag

      def path = File.join(root_path, translate('routes.autocompletions'))

      def http_method = :post

      def request_body = {
        required: false,
        description: '',
        content: {
          'multipart/form-data': {
            schema: {
              type: 'object',
              properties: {
                'autocompletion[query]': {
                  type: 'string',
                  required: true
                }
              }
            }
          },
          'application/json': {
            schema: {
              type: 'object',
              properties: {
                autocompletion: {
                  type: 'object',
                  properties: {
                    query: {
                      type: 'string'
                    }
                  },
                  required: %w[query]
                }
              }
            }
          }
        }
      }

      def responses = [
        Components::Response.new(
          code: 200,
          description: translate('open_api.responses.success'),
          data: %w[string]
        ),
        Components::Response.bad_request,
        Components::Response.not_authorized,
        Components::Response.forbidden
      ]
    end
  end
end
