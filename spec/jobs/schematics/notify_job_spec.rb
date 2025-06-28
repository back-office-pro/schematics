# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::NotifyJob do
  include_context 'with user'

  let(:shard) { :default }
  let(:comment) { Comment.create!(author: user, record: user, content: 'Hello!') }

  it { is_expected.to be_a(Schematics::Shardable) }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(shard, 'Comment', comment.id, 'mention', user.id) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .with(shard, 'Comment', comment.id, 'mention', user.id)
        .on_queue('low')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) do
      described_class.perform_now(shard, 'Comment', comment.id, 'mention', user.id)
    end

    it 'creates a new version' do
      expect { perform_now }.to change(Schematics::Version, :count).by(1)
    end
  end
end
