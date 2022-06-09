# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::MigrateSchemaJob do
  let(:schema_dataset) { SchemaDataset.create! }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(schema_dataset) }
        .to have_enqueued_job(described_class)
        .with(schema_dataset)
    end
  end
end
