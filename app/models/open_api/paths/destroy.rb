# frozen_string_literal: true

module OpenAPI
  module Paths
    class Destroy < Path
      protected

      def path = "#{root_path}/{id}"

      def http_method = :delete

      def parameters = super.push(Components::Parameter.id)

      def responses = [
        Components::Response.new(code: 204, description: 'Success'),
        Components::Response.new(code: 401, description: 'Not Authorized'),
        Components::Response.new(code: 404, description: 'Not Found')
      ]
    end
  end
end
