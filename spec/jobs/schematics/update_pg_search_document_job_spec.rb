# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::UpdatePgSearchDocumentJob do
  include_context 'with user'

  describe '#perform_later' do
    before { user.create_or_update_pg_search_document }

    it 'queues the job' do
      expect { described_class.perform_later(user) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .on_queue('reindex')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(user) }

    it 'creates the pg_search document' do
      expect { perform_now }
        .to change(PgSearch::Document, :count)
        .by(1)
    end
  end
end
