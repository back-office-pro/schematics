# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::MigrateSchemaJob do
  let(:schema_dataset) { SchemaDataset.create!(data:, state: :in_progress) }
  let(:admin_role) { Role.create!(name: 'Admin') }
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

  before { admin_role }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(schema_dataset) }
        .to have_enqueued_job(described_class)
        .with(schema_dataset)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(schema_dataset) }

    it 'changes the schema dataset state from in_progress to migrated' do
      expect { perform_now }
        .to change { schema_dataset.reload.state }
        .from('in_progress')
        .to('migrated')
    end
  end
end
