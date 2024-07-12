# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::DataCleaningJob do
  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }
        .to have_enqueued_job(described_class)
        .on_queue('cleanups')
    end
  end

  xdescribe '#perform_now' do
    subject(:perform_now) { described_class.perform_now }
  end
end
