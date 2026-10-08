# frozen_string_literal: true

module OpenAPI
  module Paths
    class Destroy < Path
      protected

      def path = "#{root_path}/{id}"

      def http_method = :delete

      def parameters = super.push(Components::Parameter.id)

      def responses = [
        Components::Response.success(code: 204),
        Components::Response.not_authorized,
        Components::Response.forbidden,
        Components::Response.not_found
      ]
    end
  end
end
