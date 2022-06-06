# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CleanSearchesJob do
  include_context 'with user'

  let(:created_at) { described_class::DELAY.ago }
  let(:searches) do
    [
      Search.create!(user:, created_at:),
      Search.create!(user:, created_at:)
    ]
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class)
    end
  end

  describe '#perform_now' do
    before { searches }

    it 'cleans searches' do
      expect { described_class.perform_now }.to change(Search, :count).by(-2)
    end
  end
end
