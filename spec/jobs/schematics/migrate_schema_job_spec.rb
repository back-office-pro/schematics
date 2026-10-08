# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::MigrateSchemaJob do
  let(:migration) { Migration.create!(data:, state:) }
  let(:state) { Migration::STATE_STATE_IN_PROGRESS }
  let(:data) do
    [
      name: 'prospect',
      attributes: [
        name: 'name',
        type: 'string'
      ]
    ]
  end

  it { is_expected.to be_a(Schematics::Quietable) }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(migration) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .with(migration)
        .on_queue('critical')
        .at(:no_wait)
    end
  end
end
