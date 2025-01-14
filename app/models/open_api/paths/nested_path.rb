# frozen_string_literal: true

module OpenAPI
  module Paths
    class NestedPath < Path
      delegate :open_api_schema, to: :nested_entity, private: true

      protected

      def path
        return "#{root_path}/#{nested_entity_name.pluralize}" if singleton?

        "#{root_path}/{id}/#{nested_entity_name.pluralize}"
      end

      def http_method = :post

      def parameters = super.push(
        (Components::Parameter.id unless singleton?)
      )

      def request_body = Components::Request
        .new(entity: nested_entity)
        .to_h

      def responses = [
        Components::Response.new(code: 201, description: 'Success', data: open_api_schema),
        Components::Response.bad_request,
        Components::Response.not_authorized,
        Components::Response.forbidden,
        Components::Response.unprocessable_content
      ]

      def nested_entity_name = self
        .class.name
        .demodulize
        .downcase

      def nested_entity = entity
        .schema
        .find_entity_by_name(nested_entity_name)
    end
  end
end
