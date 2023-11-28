# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebhookEndpoint do
  include Schematics::Specs::Model

  describe '#request' do
    subject(:request) { record.request(body) }

    let(:body) { { 'event' => 'user.update', 'payload' => {} } }

    before { stub_request(:get, record.url).to_return(status: 200) }

    it { is_expected.to be_a(Net::HTTPOK) }
  end

  describe '.broadcast_all' do
    subject(:broadcast_all) { described_class.broadcast_all(event, payload) }

    let(:event) { record.events.first }
    let(:payload) { {} }

    before { record.save! }

    it 'enqueues a webhook job' do
      expect { broadcast_all }
        .to have_enqueued_job(Schematics::WebhookJob)
        .with(WebhookRequest)
        .on_queue('webhooks')
    end
  end
end
