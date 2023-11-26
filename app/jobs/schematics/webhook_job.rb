# frozen_string_literal: true

module Schematics
  class WebhookJob < ApplicationJob
    retry_on StandardError, wait: :polynomially_longer, attempts: 5

    # :reek:UncommunicativeVariableName
    def perform(webhook_event)
      response = Net::HTTP.post_form(webhook_event.webhook_endpoint.uri, webhook_event.body)
      webhook_event.update!(
        state: WebhookEvent::STATE_STATE_BROADCASTED,
        response_body: JSON.parse(response.body),
        response_code: response.code
      )
    rescue StandardError => e
      webhook_event.state_error!
      raise e
    end
  end
end
