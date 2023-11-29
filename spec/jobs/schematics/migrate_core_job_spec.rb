# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::MigrateCoreJob do
  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }
        .to have_enqueued_job(described_class)
        .on_queue('migrations')
    end
  end
end
