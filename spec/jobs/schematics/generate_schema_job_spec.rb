# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::GenerateSchemaJob do
  let(:migration) { Migration.create! }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(migration) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .with(migration)
        .on_queue('migrations')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(migration) }

    include_context 'with openai stub'

    it 'loads data from gateway' do
      expect { perform_now }.to change(migration, :data)
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

      it 'switches state back to editing after discard' do
        expect { perform_now }.not_to change(migration, :state)
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

      it 'switches state back to editing after discard' do
        expect { perform_now }.not_to change(migration, :state)
      end
    end
  end
end
