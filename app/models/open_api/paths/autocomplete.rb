# frozen_string_literal: true

module OpenAPI
  module Paths
    class Autocomplete < Path
      protected

      def path = "#{root_path}/autocompletions"

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
        Components::Response.new(code: 200, description: 'Success', data: %w[string]),
        Components::Response.new(code: 400, description: 'Bad Request'),
        Components::Response.new(code: 401, description: 'Not Authorized')
      ]
    end
  end
end
