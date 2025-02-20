# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module WebhookEndpoint
    extend ActiveSupport::Concern

    prepended do
      validates :url, exclusion: { in: :denied_urls }
      scope :subscribed, WebhookEndpoints::SubscribedQuery
    end

    class_methods do
      def broadcast_all(event, payload)
        ActiveJob.perform_all_later(
          subscribed(event)
            .map { ::WebhookRequest.create!(webhook_endpoint: it, event:, payload:) }
            .map(&Schematics::TriggerWebhookJob.method(:new))
        )
      end
    end

    private

    def denied_urls = events
      .map(&:webhook_url)
      .uniq
  end
end
