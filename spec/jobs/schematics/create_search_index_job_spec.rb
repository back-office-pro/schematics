# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CreateSearchIndexJob do
  include_context 'with user'

  describe '#perform_later' do
    before { user.create_search_index }

    it 'queues the job' do
      expect { described_class.perform_later(user) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .on_queue('low')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(user) }

    it 'creates the search index' do
      expect { perform_now }
        .to change(Schematics::SearchIndex, :count)
        .by(1)
    end
  end
end
