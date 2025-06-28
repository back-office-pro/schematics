# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::GenerateSchemaJob do
  let(:shard) { :default }
  let(:migration) { Migration.create! }

  it { is_expected.to be_a(Schematics::Shardable) }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(shard, migration.id) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .with(shard, migration.id)
        .on_queue('critical')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(shard, migration.id) }

    include_context 'with openai stub'

    it 'loads data from gateway' do
      expect { perform_now }.to(change { migration.reload.data })
    end

    context 'when job has retried 5 times because of a record invalid error' do
      before do
        allow(migration)
          .to receive(:update!)
          .and_call_original
        allow(migration)
          .to receive(:update!)
          .with(data: Hash)
          .and_raise(ActiveRecord::RecordInvalid)
        allow_any_instance_of(described_class) # rubocop:disable RSpec/AnyInstance
          .to receive(:executions_for)
          .and_return(5)
      end

      it 'changes migration state from editing to no solution after discard' do
        expect { perform_now }
          .to change { migration.reload.state }
          .from(Migration::STATE_STATE_EDITING.to_s)
          .to(Migration::STATE_STATE_NO_SOLUTION.to_s)
      end
    end

    context 'when job has retried 5 times because of a faraday error' do
      before do
        allow(migration)
          .to receive(:update!)
          .and_call_original
        allow(migration)
          .to receive(:update!)
          .with(data: Hash)
          .and_raise(Faraday::Error)
        allow_any_instance_of(described_class) # rubocop:disable RSpec/AnyInstance
          .to receive(:executions_for)
          .and_return(5)
      end

      it 'changes migration state from editing to no solution after discard' do
        expect { perform_now }
          .to change { migration.reload.state }
          .from(Migration::STATE_STATE_EDITING.to_s)
          .to(Migration::STATE_STATE_NO_SOLUTION.to_s)
      end
    end
  end
end
