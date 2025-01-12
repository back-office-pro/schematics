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
        Components::Response.bad_request,
        Components::Response.not_authorized,
        Components::Response.forbidden,
        Components::Response.unprocessable_content
      ]
    end
  end
end
