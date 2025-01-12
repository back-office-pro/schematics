# frozen_string_literal: true

module OpenAPI
  module Paths
    class Comment < Path
      delegate :open_api_schema, to: :comment_entity, private: true

      protected

      def path
        return "#{root_path}/comments" if singleton?

        "#{root_path}/{id}/comments"
      end

      def http_method = :post

      def parameters = super.push(
        (Components::Parameter.id unless singleton?)
      )

      def request_body = Components::Request
        .new(entity: comment_entity)
        .to_h

      def responses = [
        Components::Response.new(code: 201, description: 'Success', data: open_api_schema),
        Components::Response.bad_request,
        Components::Response.not_authorized,
        Components::Response.forbidden,
        Components::Response.unprocessable_content
      ]

      def comment_entity = entity
        .schema
        .find_entity_by_name('comment')
    end
  end
end
