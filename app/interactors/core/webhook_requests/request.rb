# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module WebhookRequests
    class Request
      include Interactor

      HEADER_SIGNATURE_KEY = 'x-backoffice-signature'
      TIMEOUT_OPTIONS = {
        open_timeout: 5,
        read_timeout: 5,
        write_timeout: 5,
        max_retries: 0
      }.freeze

      delegate :webhook_request, to: :context, private: true
      delegate :webhook_endpoint, :body, to: :webhook_request, private: true
      delegate :url, :request_method, :secret_key, to: :webhook_endpoint, private: true

      # :reek:UncommunicativeVariableName
      def call
        webhook_request.update!(
          state: ::WebhookRequest::STATE_STATE_BROADCASTED,
          response_body: parsed_response_body,
          response_code: response.code
        )
      rescue StandardError => e
        webhook_request.update!(
          state: ::WebhookRequest::STATE_STATE_ERROR,
          response_body: { error: e.message }
        )
        raise e
      end

      private

      memoize def response
        Net::HTTP.start(uri.hostname, uri.port, **TIMEOUT_OPTIONS, use_ssl:) do |http|
          http.request(
            Net::HTTP
              .const_get(request_method.downcase.camelize)
              .new(uri)
              .tap { _1[HEADER_SIGNATURE_KEY] = secret_key }
              .tap { _1.form_data = body }
          )
        end
      end

      def parsed_response_body
        JSON.parse(response.body)
      rescue JSON::ParserError
        response.body
      end

      def uri = URI(url)

      def use_ssl # rubocop:disable Naming/PredicateMethod
        uri.scheme == 'https'
      end
    end
  end
end
