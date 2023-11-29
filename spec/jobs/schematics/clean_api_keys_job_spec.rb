# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CleanApiKeysJob do
  let(:permissions) { [Permission.create!(action: 'index', model: 'User')] }
  let(:api_keys) do
    [
      ApiKey.create!(name: 'First API key', permissions:, expires_at:),
      ApiKey.create!(name: 'Second API key', permissions:, expires_at:)
    ]
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }
        .to have_enqueued_job(described_class)
        .on_queue('cleanups')
    end
  end

  describe '#perform_now' do
    before { api_keys }

    context 'when API keys are active' do
      let(:expires_at) { nil }

      it 'does not archive API keys' do
        expect { described_class.perform_now }.not_to change(ApiKey, :count)
      end

      it 'does not destroy API keys' do
        expect { described_class.perform_now }.not_to change(ApiKey.with_deleted, :count)
      end
    end

    context 'when API keys are not active' do
      let(:expires_at) { described_class::DELAY.ago }

      it 'archives API keys' do
        expect { described_class.perform_now }
          .to change(ApiKey, :count)
          .by(-2)
      end

      it 'does not destroy API keys' do
        expect { described_class.perform_now }.not_to change(ApiKey.with_deleted, :count)
      end
    end
  end
end
