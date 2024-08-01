# frozen_string_literal: true

module Schematics
  class WebhookJob < ApplicationJob
    include Quietable
    queue_as :webhooks

    retry_on StandardError, wait: :polynomially_longer, attempts: 5

    def perform(webhook_request)
      return if webhook_request.state_in_progress?

      webhook_request.state_in_progress!
      Core::WebhookRequests::Fetch.call(webhook_request:)
    end
  end
end
