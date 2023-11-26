# frozen_string_literal: true

class WebhookEndpoint < Schematics::ApplicationRecord
  TIMEOUT_OPTIONS = { open_timeout: 5, read_timeout: 5, write_timeout: 5 }.freeze

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

  def request(body)
    Net::HTTP.start(uri.hostname, uri.port, **TIMEOUT_OPTIONS.merge(use_ssl:)) do |http|
      http.request(
        Net::HTTP::Post
          .new(uri)
          .tap { _1['X-BackOffice-Signature'] = secret_key }
          .tap { _1.form_data = body }
      )
    end
  end

  private

  def use_ssl
    uri.scheme == 'https'
  end
end
