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
        Components::Response.new(code: 401, description: 'Not Authorized'),
        Components::Response.new(code: 404, description: 'Not Found'),
        Components::Response.new(
          code: 200,
          description: 'Success',
          data: open_api_schema_with_associations
        )
      ]
    end
  end
end
