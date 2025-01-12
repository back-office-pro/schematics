# frozen_string_literal: true

module OpenAPI
  module Paths
    class Duplicate < Path
      protected

      def path = "#{root_path}/{id}/duplicate"

      def http_method = :post

      def parameters = super.push(Components::Parameter.id)

      def responses = [
        Components::Response.new(code: 201, description: 'Success', data: open_api_schema),
        Components::Response.new(code: 400, description: 'Bad Request'),
        Components::Response.new(code: 401, description: 'Not Authorized'),
        Components::Response.new(code: 422, description: 'Unprocessable Content')
      ]
    end
  end
end
