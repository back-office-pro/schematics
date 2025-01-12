# frozen_string_literal: true

module OpenAPI
  module Paths
    # :reek:Attribute
    class Path
      include ::ActiveModel::API
      attr_accessor :entity

      delegate :searchable_elements,
               :model_class,
               :class_name,
               :open_api_schema,
               :open_api_body,
               :open_api_schema_with_associations,
               to: :entity,
               private: true

      def to_h = {
        path => {
          http_method => {
            summary:,
            operationId: operation_id,
            tags:,
            parameters: parameters.compact.sort_by(&:name).map(&:to_h),
            requestBody: request_body,
            responses: responses.map(&:to_h).reduce(&:deep_merge)
          }.compact
        }
      }

      protected

      def summary = "#{self.class.name.demodulize.underscore.humanize}_#{model_class.human_name}"

      def operation_id = "#{class_name}_#{self.class.name.demodulize}"

      def tags = [model_class.human_name_plural.humanize]

      def parameters = [
        Components::Parameter.new(
          name: 'x-api-inflection',
          type: 'string',
          in: 'header',
          description: 'Inflect payload keys. Possible values are camel, dash, snake or pascal.'
        )
      ]

      def request_body = nil

      def singleton?
        entity in Schematics::Entities::Singleton
      end

      def root_path = class_name
        .gsub('ActiveStorage', 'Storage')
        .gsub('Blob', 'File')
        .underscore
        .then_tap { it.pluralize unless singleton? }
        .tr('_', '-')
        .prepend('/')
    end
  end
end
