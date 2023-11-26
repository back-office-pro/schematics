# frozen_string_literal: true

class WebhookEndpoint < Schematics::ApplicationRecord
  scope :subscribed, ::Core::WebhookEndpoints::SubscribedQuery

  attribute :subscriptions, default: lambda {
    Tenant
      .schema
      .entities
      .reject(&:hidden?)
      .reject(&:existing?)
      .map { "#{_1.name}.created" }
  }

  class << self
    def broadcast_all(event, payload)
      ActiveJob.perform_all_later(
        subscribed(event)
          .map { WebhookEvent.create!(webhook_endpoint: _1, event:, payload:) }
          .map(&Schematics::WebhookJob.method(:new))
      )
    end
  end

  def uri = URI(url)
end
