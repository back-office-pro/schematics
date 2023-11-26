# frozen_string_literal: true

class WebhookEvent < Schematics::ApplicationRecord
  def after_retry_event
    Schematics::WebhookJob.perform_later(self)
  end

  memoize def response
    webhook_endpoint.request(body)
  end

  private

  def body = { event:, payload: }.stringify_keys
end
