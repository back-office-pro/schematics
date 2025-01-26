# frozen_string_literal: true

class ::WebhookRequest < Schematics::ApplicationRecord
  def after_retry_event
    Schematics::TriggerWebhookJob.perform_later(self)
  end

  def body = { event: event.webhook_event, payload: }.stringify_keys
end
