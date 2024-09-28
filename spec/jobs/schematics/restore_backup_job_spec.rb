# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::RestoreBackupJob do
  let(:backup) { Backup.create!(file:, state:) }
  let(:state) { Backup::STATE_STATE_RESTORING }
  let(:file) { Core::Backups::Create.call.file }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(backup) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .on_queue('backups')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(backup) }

    it 'restores the database backup' do
      expect { perform_now }.not_to change(backup, :state)
    end
  end
end
