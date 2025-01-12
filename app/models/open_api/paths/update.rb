# frozen_string_literal: true

module OpenAPI
  module Paths
    # :reek:Attribute
    class Update < Path
      attr_accessor :http_method

      protected

      def path
        return root_path if singleton?

        "#{root_path}/{id}"
      end

      def request_body = Components::Request
        .new(entity:)
        .to_h

      def parameters = super.push(
        (Components::Parameter.id unless singleton?)
      )

      def responses = [
        Components::Response.new(code: 204, description: 'Success'),
        Components::Response.new(code: 400, description: 'Bad Request'),
        Components::Response.new(code: 401, description: 'Not Authorized'),
        Components::Response.new(code: 404, description: 'Not Found'),
        Components::Response.new(code: 422, description: 'Unprocessable Content')
      ]
    end
  end
end
