# frozen_string_literal: true

module OpenAPI
  module Paths
    class Create < Path
      protected

      alias path root_path

      def http_method = :post

      def request_body = Components::Request
        .new(entity:)
        .to_h

      def responses = [
        Components::Response.new(code: 201, description: 'Success', data: open_api_schema),
        Components::Response.new(code: 400, description: 'Bad Request'),
        Components::Response.new(code: 401, description: 'Not Authorized'),
        Components::Response.new(code: 422, description: 'Unprocessable Content')
      ]
    end
  end
end
