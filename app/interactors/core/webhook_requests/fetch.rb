# frozen_string_literal: true

module Core
  module WebhookRequests
    class Fetch
      include Interactor
      delegate :webhook_request, to: :context, private: true

      # :reek:UncommunicativeVariableName
      def call
        webhook_request.update!(
          state: ::WebhookRequest::STATE_STATE_BROADCASTED,
          response_body: JSON.parse(webhook_request.response.body),
          response_code: webhook_request.response.code
        )
      rescue StandardError => e
        webhook_request.update!(
          state: ::WebhookRequest::STATE_STATE_ERROR,
          response_body: { error: e.message }
        )
        raise e
      end
    end
  end
end
