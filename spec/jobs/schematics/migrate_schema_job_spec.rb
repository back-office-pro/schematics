# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::MigrateSchemaJob do
  let(:data) { {} }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(data) }
        .to have_enqueued_job(described_class)
        .with(data)
    end
  end
end
