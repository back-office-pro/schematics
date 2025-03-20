# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module OpenAPI
  module Paths
    class Create < Path
      protected

      alias path root_path

      def http_method = :post

      def request_body = Components::Request
        .new(entity:)
        .to_h

      def responses = [
        Components::Response.success(data: open_api_schema),
        Components::Response.bad_request,
        Components::Response.not_authorized,
        Components::Response.forbidden,
        Components::Response.unprocessable_content
      ]
    end
  end
end
