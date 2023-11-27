# frozen_string_literal: true

class WebhookEndpoint < Schematics::ApplicationRecord
  TIMEOUT_OPTIONS = { open_timeout: 5, read_timeout: 5, write_timeout: 5, max_retries: 0 }.freeze
  HEADER_SIGNATURE_KEY = 'X-BackOffice-Signature'.freeze

  scope :subscribed, ::Core::WebhookEndpoints::SubscribedQuery

  class << self
    def broadcast_all(event, payload)
      ActiveJob.perform_all_later(
        subscribed(event)
          .map { WebhookRequest.create!(webhook_endpoint: _1, event:, payload:) }
          .map(&Schematics::WebhookJob.method(:new))
      )
    end
  end

  def request(body)
    Net::HTTP.start(uri.hostname, uri.port, **TIMEOUT_OPTIONS.merge(use_ssl:)) do |http|
      http.request(
        Net::HTTP
          .const_get(request_method.downcase.camelize)
          .new(uri)
          .tap { _1[HEADER_SIGNATURE_KEY] = secret_key }
          .tap { _1.form_data = body }
      )
    end
  end

  private

  def uri = URI(url)

  def use_ssl
    uri.scheme == 'https'
  end
end
