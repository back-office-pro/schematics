# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::MigrateSchemaJob do
  let(:migration) { Migration.create!(data:, state: :in_progress) }
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
    end
  end
end
