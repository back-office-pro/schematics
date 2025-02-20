# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module OpenAPI
  module Paths
    class NestedPath < Path
      delegate :open_api_schema, to: :nested_entity, private: true

      protected

      def path
        return File.join(root_path, nested_path) if singleton?

        File.join(root_path, '{id}', nested_path)
      end

      def nested_path = translate(:other, scope: [:activerecord, :models, nested_entity_name])
        .parameterize(separator: '-')

      def http_method = :post

      def parameters = super.push(
        (Components::Parameter.id unless singleton?)
      )

      def request_body = Components::Request
        .new(entity: nested_entity)
        .to_h

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

      def nested_entity_name = self
        .class
        .name
        .demodulize
        .downcase

      def nested_entity = entity
        .schema
        .find_entity_by_name(nested_entity_name)
    end
  end
end
