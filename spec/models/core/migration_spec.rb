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
        state: finished
        data_version: 1.5
        data: []
    YAML
  end

  describe '#finalize!' do
    subject(:finalize!) { record.finalize!(failure) }

    context 'when migration has succeeded' do
      let(:failure) { false }

      it 'changes migration state from in_progress to finished' do
        expect { finalize! }
          .to change(record, :state)
          .from('pending')
          .to('finished')
      end
    end

    context 'when migration has failed' do
      let(:failure) { true }

      it 'changes migration state from in_progress to error' do
        expect { finalize! }
          .to change(record, :state)
          .from('pending')
          .to('error')
      end
    end
  end
end
