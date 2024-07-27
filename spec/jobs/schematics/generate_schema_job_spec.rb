# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::GenerateSchemaJob do
  let(:migration) { Migration.create! }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(migration) }
        .to have_enqueued_job(described_class)
        .with(migration)
        .on_queue('default')
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(migration) }

    include_context 'with openai stub'

    it 'loads data from gateway' do
      expect { perform_now }.to change(migration, :data)
    end
  end
end
