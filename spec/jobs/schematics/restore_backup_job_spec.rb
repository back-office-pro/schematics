# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::RestoreBackupJob do
  let(:backup) { Backup.create!(file:, state:).reload }
  let(:state) { Backup::STATE_STATE_RESTORING }

  include_context 'with import'

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

    it 'updates the backup state from restoring to ready' do
      expect { perform_now }
        .to change(backup, :state)
        .from(Backup::STATE_STATE_RESTORING.to_s)
        .to(Backup::STATE_STATE_READY.to_s)
    end
  end
end
