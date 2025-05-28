# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::RestoreBackupJob do
  let(:shard) { :demo }
  let(:backup) { Backup.create!(file:, state:) }
  let(:state) { Backup::STATE_STATE_RESTORING }
  let(:file) { Core::Backups::Create.call.file }

  it { is_expected.to be_a(Schematics::Shardable) }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(shard, backup.id) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .on_queue('critical')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(shard, backup.id) }

    it 'restores the database backup' do
      expect { perform_now }.not_to change(backup, :state)
    end

    context 'when there is a file not found error' do
      before do
        allow(ActiveRecord::Base.connection_pool)
          .to receive(:disconnect!)
          .and_return(nil)
        allow(file)
          .to receive(:open)
          .and_raise(ActiveStorage::FileNotFoundError)
      end

      it 'changes backup state from restoring to error after discard' do
        expect { perform_now }
          .to change { backup.reload.state }
          .from(Backup::STATE_STATE_RESTORING.to_s)
          .to(Backup::STATE_STATE_ERROR.to_s)
      end
    end
  end
end
