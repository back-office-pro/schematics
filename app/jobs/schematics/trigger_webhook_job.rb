# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class TriggerWebhookJob < ApplicationJob
    include Shardable
    include Quietable

    queue_as :low

    retry_on StandardError, wait: :polynomially_longer, attempts: 5

    def perform(_shard, webhook_request_id)
      webhook_request = ::WebhookRequest.find(webhook_request_id)
      return if webhook_request.state_in_progress?
      return if webhook_request.state_broadcasted?

      webhook_request.state_in_progress!
      Core::WebhookRequests::Request.call(webhook_request:)
    end
  end
end
