# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module OpenAPI
  module Paths
    class Duplicate < Path
      protected

      def path = File.join(root_path, '{id}', translate('routes.duplicate'))

      def http_method = :post

      def parameters = super.push(Components::Parameter.id)

      def responses = [
        Components::Response.new(
          code: 201,
          description: translate('open_api.responses.success'),
          data: open_api_schema
        ),
        Components::Response.bad_request,
        Components::Response.not_authorized,
        Components::Response.forbidden,
        Components::Response.unprocessable_content
      ]
    end
  end
end
