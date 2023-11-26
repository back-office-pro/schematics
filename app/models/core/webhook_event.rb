# frozen_string_literal: true

class WebhookEvent < Schematics::ApplicationRecord
  def body = { event:, payload: }.stringify_keys

  def after_retry_event
    Schematics::WebhookJob.perform_later(self)
  end
end
