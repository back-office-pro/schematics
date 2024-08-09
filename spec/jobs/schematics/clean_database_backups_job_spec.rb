# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CleanDatabaseBackupsJob do
  let(:checksum) { 0 }
  let(:byte_size) { 0 }
  let(:filename) { 'db.dump' }
  let(:content_type) { Mime[:binary].to_s }
  let(:backups) do
    ActiveStorage::Blob.create!(
      [
        { key: 'backups/1', filename:, checksum:, byte_size:, content_type: },
        { key: 'backups/2', filename:, checksum:, byte_size:, content_type: },
        { key: 'backups/3', filename:, checksum:, byte_size:, content_type: },
        { key: 'backups/4', filename:, checksum:, byte_size:, content_type: },
        { key: 'backups/5', filename:, checksum:, byte_size:, content_type: },
        { key: 'backups/6', filename:, checksum:, byte_size:, content_type: },
        { key: 'backups/7', filename:, checksum:, byte_size:, content_type: },
        { key: 'backups/8', filename:, checksum:, byte_size:, content_type: }
      ]
    )
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .on_queue('cleanups')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now }

    before { backups }

    it 'destroys the 8th backup' do
      expect { perform_now }
        .to change(ActiveStorage::Blob.with_deleted, :count)
        .by(-1)
    end

    it 'purges the 8th backup' do
      perform_now
      expect(ActiveStorage::Blob.service).not_to exist('backups/8')
    end
  end
end
