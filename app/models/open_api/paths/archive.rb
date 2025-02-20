# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module OpenAPI
  module Paths
    class Archive < Path
      protected

      def path = File.join(root_path, '{id}', translate('routes.archive'))

      def http_method = :delete

      def parameters = super.push(Components::Parameter.id)

      def responses = [
        Components::Response.new(
          code: 204,
          description: translate('open_api.responses.success')
        ),
        Components::Response.not_authorized,
        Components::Response.forbidden,
        Components::Response.not_found
      ]
    end
  end
end
