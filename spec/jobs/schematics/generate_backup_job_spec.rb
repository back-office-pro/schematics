# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::GenerateBackupJob do
  include ActiveSupport::Testing::TimeHelpers

  let(:time) { Time.parse('2021/01/01 10:00 +0000') }

  before { travel_to(time) }

  it { is_expected.to be_a(Schematics::Quietable) }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .on_queue('critical')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now }

    it 'performs database backup' do
      expect { perform_now }
        .to change(Backup, :count)
        .by(1)
    end

    it 'uploads the backup dump file' do
      perform_now
      expect(ActiveStorage::Blob.service).to exist('backups/2021_01_01_10_00_00_000/db.dump')
    end
  end
end
