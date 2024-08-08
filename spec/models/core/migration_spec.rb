# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Migration do
  include Schematics::Specs::Model

  it { is_expected.not_to be_processing }

  its(:migrator) { is_expected.to be_a(Schematics::Migrator) }
  its(:commit_message) { is_expected.to eq('Migration v1.5 (core v1.0.0)') }

  its(:to_yaml) do
    is_expected.to eq <<~YAML
      ---
      one:
        state: finished
        version: 1.5
        data: []
    YAML
  end

  it 'enqueues a migrate schema job after migrate' do
    expect { record.migrate! }
      .to have_enqueued_job(Schematics::MigrateSchemaJob)
      .exactly(:once)
      .with(record)
      .on_queue('migrations')
      .at(:no_wait)
  end

  it 'enqueues a generate schema job after save' do
    expect { record.save! }
      .to have_enqueued_job(Schematics::GenerateSchemaJob)
      .exactly(:once)
      .with(record)
      .on_queue('migrations')
      .at(:no_wait)
  end

  describe '#finalize!' do
    subject(:finalize!) { record.finalize!(failure) }

    context 'when migration has succeeded' do
      let(:failure) { false }

      it 'changes migration state from editing to finished' do
        expect { finalize! }
          .to change(record, :state)
          .from(described_class::STATE_STATE_EDITING.to_s)
          .to(described_class::STATE_STATE_FINISHED.to_s)
      end
    end

    context 'when migration has failed' do
      let(:failure) { true }

      it 'changes migration state from editing to error' do
        expect { finalize! }
          .to change(record, :state)
          .from(described_class::STATE_STATE_EDITING.to_s)
          .to(described_class::STATE_STATE_ERROR.to_s)
      end
    end
  end

  describe '.core' do
    subject { described_class.core }

    before { record.state_finished! }

    it { is_expected.to be_a(described_class) }
    its(:version) { is_expected.to eq(1.5) }
  end

  describe '.current' do
    subject { described_class.current }

    before { record.state_finished! }

    it { is_expected.to eq(record) }
  end

  describe '.scheduled' do
    subject { described_class.scheduled }

    before { record.state_scheduled! }

    it { is_expected.to eq(record) }
  end

  describe '.default' do
    subject { described_class.default }

    it { is_expected.to be_a(described_class) }
  end
end
