# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class ::WebhookEndpoint < Schematics::ApplicationRecord
  validates :url, exclusion: { in: :denied_urls }

  scope :subscribed, ::Core::WebhookEndpoints::SubscribedQuery

  class << self
    def broadcast_all(event, payload)
      ActiveJob.perform_all_later(
        subscribed(event)
          .map { WebhookRequest.create!(webhook_endpoint: _1, event:, payload:) }
          .map(&Schematics::TriggerWebhookJob.method(:new))
      )
    end
  end

  private

  def denied_urls = events
    .map(&:webhook_url)
    .uniq
end
