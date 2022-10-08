# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CleanApiRequestsJob do
  let(:created_at) { described_class::DELAY.ago }
  let(:api_key) { ApiKey.create!(name: 'API key') }
  let(:api_requests) do
    [
      ApiRequest.create!(api_key:, created_at:),
      ApiRequest.create!(api_key:, created_at:)
    ]
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class)
    end
  end

  describe '#perform_now' do
    before { api_requests }

    it 'cleans API requests' do
      expect { described_class.perform_now }.to change(ApiRequest, :count).by(-2)
    end
  end
end
