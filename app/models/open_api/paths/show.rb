# frozen_string_literal: true

module OpenAPI
  module Paths
    class Show < Path
      protected

      def path = "#{root_path}/{id}"

      def http_method = :get

      def parameters = super.push(Components::Parameter.id)

      def responses = [
        Components::Response.not_authorized,
        Components::Response.forbidden,
        Components::Response.not_found,
        Components::Response.new(
          code: 200,
          description: translate('open_api.responses.success'),
          data: open_api_schema_with_associations
        )
      ]
    end
  end
end
