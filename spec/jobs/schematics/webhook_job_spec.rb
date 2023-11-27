# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::WebhookJob do
  let(:event) { Permission.create!(model: 'User', action: 'create') }
  let(:webhook_request) { WebhookRequest.create!(event:, webhook_endpoint:) }
  let(:webhook_endpoint) do
    WebhookEndpoint.create!(
      url: 'https://www.nowhere.com',
      events: [event]
    )
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(webhook_request) }
        .to have_enqueued_job(described_class)
        .with(webhook_request)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(webhook_request) }

    before { stub_request(:post, webhook_endpoint.url).to_return(body: '{}', status: 200) }

    it 'updates the response code' do
      expect { perform_now }
        .to change(webhook_request, :response_code)
        .from(nil)
        .to(200)
    end

    it 'updates the response body' do
      expect { perform_now }
        .to change(webhook_request, :response_body)
        .from(nil)
        .to({})
    end
  end
end
