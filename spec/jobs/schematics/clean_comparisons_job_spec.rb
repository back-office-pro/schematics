# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CleanComparisonsJob do
  let(:created_at) { described_class::DELAY.ago }
  let(:comparisons) { create_list(:comparison, 2, model: 'User', created_at:) }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class)
    end
  end

  describe '#perform_now' do
    before { comparisons }

    it 'cleans searches' do
      expect { described_class.perform_now }.to change(Comparison, :count).by(-2)
    end
  end
end
