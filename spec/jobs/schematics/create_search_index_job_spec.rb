# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CreateSearchIndexJob do
  include_context 'with user'

  let(:shard) { :default }

  it { is_expected.to be_a(Schematics::Shardable) }

  describe '#perform_later' do
    before { user.create_search_index }

    it 'queues the job' do
      expect { described_class.perform_later(shard, 'User', user.id) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .on_queue('low')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(shard, 'User', user.id) }

    it 'creates the search index' do
      expect { perform_now }
        .to change(Schematics::SearchIndex, :count)
        .by(1)
    end
  end
end
