# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CleanDatabaseBackupsJob do
  let(:created_at) { described_class::DELAY.ago }
  let(:checksum) { 0 }
  let(:byte_size) { 0 }
  let(:filename) { 'db.dump' }
  let(:backups) do
    ActiveStorage::Blob.create!(
      [
        { key: 'backups/1', filename:, checksum:, byte_size:, created_at: },
        { key: 'backups/2', filename:, checksum:, byte_size:, created_at: }
      ]
    )
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }
        .to have_enqueued_job(described_class)
        .on_queue('cleanups')
    end
  end

  describe '#perform_now' do
    before { backups }

    it 'destroys backups' do
      expect { described_class.perform_now }
        .to change(ActiveStorage::Blob.with_deleted, :count)
        .by(-2)
    end
  end
end
