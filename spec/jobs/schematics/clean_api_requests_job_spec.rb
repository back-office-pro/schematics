# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CleanAPIRequestsJob do
  let(:created_at) { described_class::DELAY.ago }
  let(:permissions) { [Permission.create!(action: 'index', model: 'User')] }
  let(:api_key) { APIKey.create!(name: 'API key', permissions:) }
  let(:api_requests) do
    [
      APIRequest.create!(api_key:, created_at:),
      APIRequest.create!(api_key:, created_at:)
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
    before { api_requests }

    it 'destroys API requests' do
      expect { described_class.perform_now }
        .to change(APIRequest.with_deleted, :count)
        .by(-2)
    end
  end
end
