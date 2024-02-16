# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::MigrateSchemaJob do
  let(:migration) { Migration.create!(data:, state:) }
  let(:state) { Migration::STATE_STATE_IN_PROGRESS }
  let(:data) do
    [
      {
        name: 'prospect',
        attributes: [
          {
            name: 'name',
            type: 'string'
          }
        ]
      }
    ]
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(migration) }
        .to have_enqueued_job(described_class)
        .with(migration)
        .on_queue('migrations')
    end
  end

  describe '.wait_for' do
    subject(:wait_for) { described_class.wait_for(migration) }

    before do
      allow(Tenant).to receive(:backend).and_return(Backend::Redis.new)
      wait_for
    end

    context 'when the migration is successful' do
      it 'updates tenant schema' do
        expect { migration.finalize!(false) && sleep(5) }.to change(Tenant, :schema)
      end
    end

    context 'when the migration has failed' do
      it 'does not update tenant schema' do
        expect { migration.finalize!(true) && sleep(5) }.not_to change(Tenant, :schema)
      end
    end
  end
end
