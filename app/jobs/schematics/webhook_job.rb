# frozen_string_literal: true

module Schematics
  class WebhookJob < ApplicationJob
    def perform(webhook_event)
      response = Net::HTTP.start(uri.hostname, uri.port, **http_options) do |http|
        http.request(
          Net::HTTP
            .const_get(webhook_event.webhook_endpoint.method.camelize)
            .new(uri)
            .tap { _1.body = webhook_event.payload.to_json }
        )
      end
      webhook_event.update!(response: response.body, status: response.code)
    end
  end
end
