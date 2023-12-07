# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Migration do
  include Schematics::Specs::Model

  its(:migrator) { is_expected.to be_a(Schematics::Migrator) }
  its(:commit_message) { is_expected.to eq('Migration v1.5 (core v1.0.0)') }

  its(:to_yaml) do
    is_expected.to eq <<~YAML
      ---
      one:
        state: :finished
        data_version: 1.5
        data: []
    YAML
  end

  describe '#finalize!' do
    subject(:finalize!) { record.finalize!(failure) }

    context 'when migration has succeeded' do
      let(:failure) { false }

      it 'changes migration state from pending to finished' do
        expect { finalize! }
          .to change(record, :state)
          .from(described_class::STATE_STATE_PENDING.to_s)
          .to(described_class::STATE_STATE_FINISHED.to_s)
      end
    end

    context 'when migration has failed' do
      let(:failure) { true }

      it 'changes migration state from pending to error' do
        expect { finalize! }
          .to change(record, :state)
          .from(described_class::STATE_STATE_PENDING.to_s)
          .to(described_class::STATE_STATE_ERROR.to_s)
      end
    end
  end

  describe '.core' do
    subject { described_class.core }

    before { record.state_finished! }

    it { is_expected.to be_a(described_class) }
    its(:data_version) { is_expected.to eq(1.5) }
  end

  describe '.current' do
    subject { described_class.current }

    before { record.state_finished! }

    it { is_expected.to eq(record) }
  end
end
