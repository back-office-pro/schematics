# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::RebuildPgSearchDocumentsJob do
  let(:model_class) { User }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(model_class) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .on_queue('reindex')
        .at(:no_wait)
    end
  end
end
