# frozen_string_literal: true

module Schematics
  class WebhookJob < ApplicationJob
    queue_as :webhooks
    retry_on StandardError, wait: :polynomially_longer, attempts: 5

    def perform(webhook_request)
      PaperTrail.request(enabled: false) do
        Core::WebhookRequests::Fetch.call(webhook_request:)
      end
    end
  end
end
