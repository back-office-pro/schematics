# frozen_string_literal: true

module OpenAPI
  module Components
    # :reek:Attribute
    class Response
      include ::ActiveModel::API
      attr_accessor :code, :description, :headers, :data

      def to_h = {
        code => {
          description:,
          content: { 'application/json': { schema: } },
          headers: Array(headers).map(&:to_h).reduce(&:merge)
        }.compact_blank
      }

      private

      def schema = Type
        .new(value: data || 'object')
        .to_h
    end
  end
end
