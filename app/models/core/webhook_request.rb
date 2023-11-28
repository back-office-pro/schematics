# frozen_string_literal: true

class WebhookRequest < Schematics::ApplicationRecord
  def after_retry_event
    Schematics::WebhookJob.perform_later(self)
  end

  memoize def response
    webhook_endpoint.request(body)
  end

  def parsed_response_body
    JSON.parse(response.body)
  rescue JSON::ParserError
    response.body
  end

  private

  def body = { event: event.webhook_event, payload: }.stringify_keys
end
