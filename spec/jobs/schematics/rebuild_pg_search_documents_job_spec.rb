# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::RebuildPgSearchDocumentsJob do
  include_context 'with user'

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

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(model_class) }

    before { user }

    it 'creates the pg_search document' do
      expect { perform_now }
        .to change(PgSearch::Document, :count)
        .by(1)
    end
  end
end
