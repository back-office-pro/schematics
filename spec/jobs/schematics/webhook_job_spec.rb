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

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(webhook_event) }

    before { stub_request(:post, webhook_endpoint.url).to_return(body: '{}', status: 200) }

    it 'updates the response code' do
      expect { perform_now }
        .to change(webhook_event, :response_code)
        .from(nil)
        .to(200)
    end

    it 'updates the response body' do
      expect { perform_now }
        .to change(webhook_event, :response_body)
        .from(nil)
        .to({})
    end
  end
end
