# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Migration do
  include Schematics::Specs::Model

  its(:locale) { is_expected.to eq('en') }
  its(:migrator) { is_expected.to be_a(Schematics::Migrator) }

  it 'enqueues a migrate schema job after migrate' do
    expect { record.migrate_state! }
      .to have_enqueued_job(Schematics::MigrateSchemaJob)
      .exactly(:once)
      .with(record)
      .on_queue('critical')
      .at(:no_wait)
  end

  it 'enqueues a rollback schema job after rollback' do
    expect { record.tap { it.finalize!(false) }.reload.rollback_state! }
      .to have_enqueued_job(Schematics::RollbackSchemaJob)
      .exactly(:once)
      .with(record)
      .on_queue('critical')
      .at(:no_wait)
  end

  it 'enqueues a generate schema job after updating prompt' do
    expect { record.tap(&:save!).reload.update!(prompt: 'prompt') }
      .to have_enqueued_job(Schematics::GenerateSchemaJob)
      .exactly(:once)
      .with(record)
      .on_queue('critical')
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
    its(:version) { is_expected.to be_zero }
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

  describe '.default_data' do
    subject { described_class.default_data }

    its([0]) do
      is_expected.to match(
        id: String,
        name: 'customer',
        options: {
          icon: 'user_tie',
          descriptor: 'full_name'
        },
        attributes: Array,
        virtuals: Array
      )
    end
  end

  describe '.default_prompt' do
    subject { described_class.default_prompt }

    it { is_expected.to eq('Create a web application in the other business sector') }
  end
end
