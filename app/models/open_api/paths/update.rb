# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module OpenAPI
  module Paths
    # :reek:Attribute
    class Update < Path
      attr_accessor :http_method

      protected

      def path = "#{root_path}/{id}"

      def operation_id = "#{super}_#{http_method.capitalize}"

      def request_body = Components::Request
        .new(entity:)
        .to_h

      def parameters = super.push(Components::Parameter.id)

      def responses = [
        Components::Response.new(
          code: 204,
          description: translate('open_api.responses.success')
        ),
        Components::Response.bad_request,
        Components::Response.not_authorized,
        Components::Response.forbidden,
        Components::Response.not_found,
        Components::Response.unprocessable_content
      ]
    end
  end
end
