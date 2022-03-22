# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CleanSearchesJob do
  fixtures :searches

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class)
    end
  end

  describe '#perform_now' do
    before { Search.update(created_at: described_class::DELAY.ago) }

    it 'cleans searches' do
      expect { described_class.perform_now }.to change(Search, :count).by(-2)
    end
  end
end
