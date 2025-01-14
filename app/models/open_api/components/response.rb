# frozen_string_literal: true

module OpenAPI
  module Components
    # :reek:Attribute
    class Response
      include ::ActiveModel::API
      attr_accessor :code, :description, :headers, :data

      class << self
        def bad_request = new(code: 400, description: 'Bad Request')

        def not_authorized = new(code: 401, description: 'Not Authorized')

        def forbidden = new(code: 403, description: 'Forbidden')

        def not_found = new(code: 404, description: 'Not Found')

        def method_not_allowed = new(code: 405, description: 'Action Not Authorized')

        def unprocessable_content = new(code: 422, description: 'Unprocessable Content')
      end

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
