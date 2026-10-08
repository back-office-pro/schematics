# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebhookEndpoint do
  include Schematics::Specs::Model
  include Schematics::ResourcesHelper

  context 'when url is malicious and would lead to an infinite loop' do
    before { record.url = resources_url(User, host: 'localhost', port: 3000) }

    it { is_expected.not_to be_valid }
  end

  describe '.broadcast_all' do
    subject(:broadcast_all) { described_class.broadcast_all(event, payload) }

    let(:event) { record.events.first }
    let(:payload) { {} }

    before { record.save! }

    it 'enqueues a trigger webhook job' do
      expect { broadcast_all }
        .to have_enqueued_job(Schematics::TriggerWebhookJob)
        .exactly(:once)
        .with(WebhookRequest)
        .on_queue('low')
        .at(:no_wait)
    end
  end
end
