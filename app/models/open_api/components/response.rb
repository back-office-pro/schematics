# frozen_string_literal: true

module OpenAPI
  module Components
    # :reek:Attribute
    class Response
      include ::ActiveModel::API

      attr_accessor :code, :description, :headers, :data

      class << self
        delegate :translate, to: '::I18n', private: true

        def success(code: 201, data: nil)
          new(code:, description: translate('open_api.responses.success'), data:)
        end

        def bad_request = new(
          code: 400,
          description: translate('open_api.responses.bad_request')
        )

        def not_authorized = new(
          code: 401,
          description: translate('open_api.responses.not_authorized')
        )

        def forbidden = new(
          code: 403,
          description: translate('open_api.responses.forbidden')
        )

        def not_found = new(
          code: 404,
          description: translate('open_api.responses.not_found')
        )

        def method_not_allowed = new(
          code: 405,
          description: translate('open_api.responses.method_not_allowed')
        )

        def unprocessable_content = new(
          code: 422,
          description: translate('open_api.responses.unprocessable_content')
        )
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
