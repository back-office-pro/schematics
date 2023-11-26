# frozen_string_literal: true

class WebhookEvent < Schematics::ApplicationRecord
  class << self
    def response_code_from_exception(exception)
      case exception
      when Timeout::TimeoutError
        504
      else
        500
      end
    end
  end

  def after_retry_event
    Schematics::WebhookJob.perform_later(self)
  end

  memoize def response = webhook_endpoint.request(body)

  private

  def body = { event:, payload: }.stringify_keys
end
