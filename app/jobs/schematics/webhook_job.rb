# frozen_string_literal: true

module Schematics
  class WebhookJob < ApplicationJob
    retry_on StandardError, wait: :polynomially_longer, attempts: 5

    # :reek:UncommunicativeVariableName
    def perform(resource)
      PaperTrail.request(enabled: false) do
        Resources::Update.call(
          resource:,
          resource_params: {
            state: WebhookEvent::STATE_STATE_BROADCASTED,
            response_body: JSON.parse(resource.response.body),
            response_code: resource.response.code
          }
        )
      rescue StandardError => e
        Resources::Update.call(
          resource:,
          resource_params: {
            state: WebhookEvent::STATE_STATE_ERROR,
            response_body: { error: e.message },
            response_code: WebhookEvent::EXCEPTION_RESPONSE_CODE[exception.class] || 500
          }
        )
        raise e
      end
    end
  end
end
