# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::WebhookJob do
  let(:webhook_event) { WebhookEvent.create!(event: 'user.update', webhook_endpoint:) }
  let(:webhook_endpoint) do
    WebhookEndpoint.create!(
      url: 'https://www.nowhere.com',
      subscriptions: ['user.update']
    )
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(webhook_event) }
        .to have_enqueued_job(described_class)
        .with(webhook_event)
    end
  end
end
