# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CleanDataJob do
  include_context 'with import'

  let(:permissions) { [Permission.create!(action: 'index', model: 'User')] }
  let(:api_keys) do
    APIKey.create!(
      [
        { name: 'First API key', permissions:, expires_at: },
        { name: 'Second API key', permissions:, expires_at: }
      ]
    )
  end
  let(:imports) do
    Import.create!(
      [
        { file:, model:, author: user, created_at: 1.year.ago },
        { file:, model:, author: user, created_at: 1.year.ago }
      ]
    )
  end
  let(:meetings) do
    Meeting.create!(
      [
        {
          subject: 'First meeting',
          creator: user,
          start_at: 1.year.ago.yesterday,
          end_at: 1.year.ago,
          participants: [user]
        },
        {
          subject: 'Second meeting',
          creator: user,
          start_at: 1.year.ago.yesterday,
          end_at: 1.year.ago,
          participants: [user]
        }
      ]
    )
  end
  let(:data_cleanings) do
    DataCleaning.create!(
      [
        { model: 'APIKey', field: 'APIKey#expires_at', period: 'year' },
        { model: 'Meeting', field: 'Meeting#end_at', period: 'year' },
        { model: 'Import', period: 'year', really_destroy: true }
      ]
    )
  end

  before { [data_cleanings, imports, meetings] }

  it { is_expected.to be_a(Schematics::Quietable) }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .on_queue('low')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now }

    context 'when API keys are active' do
      let(:expires_at) { nil }

      before { api_keys }

      it 'does not archive API keys' do
        expect { perform_now }.not_to change(APIKey, :count)
      end

      it 'does not destroy API keys' do
        expect { perform_now }.not_to change(APIKey.with_deleted, :count)
      end
    end

    context 'when API keys are not active' do
      let(:expires_at) { 1.year.ago }

      before { api_keys }

      it 'archives API keys' do
        expect { perform_now }
          .to change(APIKey, :count)
          .by(-2)
      end

      it 'does not destroy API keys' do
        expect { perform_now }.not_to change(APIKey.with_deleted, :count)
      end
    end

    it 'destroys imports' do
      expect { perform_now }
        .to change(Import.with_deleted, :count)
        .by(-2)
    end

    it 'purges import files' do
      expect { perform_now }
        .to have_enqueued_job(ActiveStorage::PurgeJob)
        .exactly(:twice)
        .with(file)
        .on_queue('low')
        .at(:no_wait)
    end

    it 'archives meetings' do
      expect { perform_now }
        .to change(Meeting, :count)
        .by(-2)
    end

    it 'does not destroy meetings' do
      expect { perform_now }.not_to change(Meeting.with_deleted, :count)
    end
  end
end
