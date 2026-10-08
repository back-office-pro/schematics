# frozen_string_literal: true

module OpenAPI
  module Paths
    # :reek:Attribute
    class Path
      include ::ActiveModel::API
      include ::ActionView::Helpers::TranslationHelper

      attr_accessor :entity

      delegate :searchable_elements,
               :class_name,
               :open_api_schema,
               :open_api_body,
               :open_api_schema_with_associations,
               to: :entity,
               private: true

      def tag = translate(:other, scope: [:activerecord, :models, entity.name])

      def to_h = {
        path.to_sym => {
          http_method => {
            summary:,
            operationId: operation_id,
            tags: [tag],
            parameters: parameters.compact.sort_by(&:name).map(&:to_h),
            requestBody: request_body,
            responses: responses.map(&:to_h).reduce(&:deep_merge)
          }.compact
        }
      }

      protected

      def summary = [
        translate(
          self.class.name.demodulize.underscore,
          scope: %i[activerecord enums permission action]
        ),
        summary_slug
      ].join(' ')

      def summary_slug = human_name

      def human_name = translate(:one, scope: [:activerecord, :models, entity.name])

      def operation_id = "#{class_name}_#{self.class.name.demodulize}"

      def parameters = [
        Components::Parameter.new(
          name: 'x-api-inflection',
          type: 'string',
          in: 'header',
          description: translate('open_api.parameters.inflection')
        )
      ]

      def request_body = nil

      def singleton?
        entity in Schematics::Entities::Singleton
      end

      def root_path = File.join('', (singleton? ? summary_slug : tag).parameterize)
    end
  end
end
