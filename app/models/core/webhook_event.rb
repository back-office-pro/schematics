# frozen_string_literal: true

class WebhookEvent < Schematics::ApplicationRecord
  EXCEPTION_RESPONSE_CODE = { Timeout::TimeoutError => 504 }.freeze

  def after_retry_event
    Schematics::WebhookJob.perform_later(self)
  end

  memoize def response = webhook_endpoint.request(body)

  private

  def body = { event:, payload: }.stringify_keys
end
