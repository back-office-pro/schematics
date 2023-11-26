# frozen_string_literal: true

module Schematics
  class WebhookJob < ApplicationJob
    retry_on StandardError, wait: :polynomially_longer, attempts: 5

    # :reek:UncommunicativeVariableName
    def perform(webhook_event)
      PaperTrail.request(enabled: false) do
        webhook_event.update!(
          state: WebhookEvent::STATE_STATE_BROADCASTED,
          response_body: JSON.parse(resource.response.body),
          response_code: resource.response.code
        )
      rescue StandardError => e
        webhook_event.update!(
          state: WebhookEvent::STATE_STATE_ERROR,
          response_body: { error: e.message }
        )
        raise e
      end
    end
  end
end
