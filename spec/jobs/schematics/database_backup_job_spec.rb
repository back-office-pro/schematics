# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::DatabaseBackupJob do
  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class)
    end
  end

  describe '#perform_now' do
    it 'performs database backup' do
      expect { described_class.perform_now }.to change(ActiveStorage::Blob, :count).by(1)
    end
  end
end
