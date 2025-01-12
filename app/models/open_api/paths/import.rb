# frozen_string_literal: true

module OpenAPI
  module Paths
    class Import < Path
      delegate :open_api_schema, to: :import_entity, private: true

      protected

      def path = "#{root_path}/imports"

      def http_method = :post

      def summary = super.pluralize

      def request_body = Components::Request
        .new(entity: import_entity)
        .to_h

      def responses = [
        Components::Response.new(code: 201, description: 'Success', data: open_api_schema),
        Components::Response.bad_request,
        Components::Response.not_authorized,
        Components::Response.forbidden,
        Components::Response.unprocessable_content
      ]

      def import_entity = entity
        .schema
        .find_entity_by_name('import')
    end
  end
end
