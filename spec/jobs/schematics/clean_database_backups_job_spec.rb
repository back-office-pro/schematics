# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CleanDatabaseBackupsJob do
  let(:created_at) { described_class::DELAY.ago }
  let(:checksum) { 0 }
  let(:byte_size) { 0 }
  let(:filename) { 'db.dump' }
  let(:backups) do
    [
      ActiveStorage::Blob.create!(key: 'backups/1', filename:, checksum:, byte_size:, created_at:),
      ActiveStorage::Blob.create!(key: 'backups/2', filename:, checksum:, byte_size:, created_at:)
    ]
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class)
    end
  end

  describe '#perform_now' do
    before { backups }

    it 'cleans backups' do
      expect { described_class.perform_now }.to change(ActiveStorage::Blob, :count).by(-2)
    end
  end
end
