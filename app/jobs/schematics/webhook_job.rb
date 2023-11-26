# frozen_string_literal: true

module Schematics
  class WebhookJob < ApplicationJob
    retry_on StandardError, wait: :polynomially_longer, attempts: 5

    # :reek:UncommunicativeVariableName
    def perform(webhook_event)
      PaperTrail.request(enabled: false) do
        Core::WebhookEvents::Fetch.call(webhook_event:)
      end
    end
  end
end
