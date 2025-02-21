# Copyright © 2025 Dev & Software. All rights reserved.
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
