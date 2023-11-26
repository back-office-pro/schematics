# frozen_string_literal: true

module Core
  module WebhookEvents
    class Fetch
      include Interactor
      delegate :webhook_event, to: :context, private: true

      def call
        webhook_event.update!(
          state: ::WebhookEvent::STATE_STATE_BROADCASTED,
          response_body: JSON.parse(webhook_event.response.body),
          response_code: webhook_event.response.code
        )
      rescue StandardError => e
        webhook_event.update!(
          state: ::WebhookEvent::STATE_STATE_ERROR,
          response_body: { error: e.message }
        )
        raise e
      end
    end
  end
end
