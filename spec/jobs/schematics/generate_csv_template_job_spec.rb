# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'
require 'turbo/broadcastable/test_helper'

RSpec.describe Schematics::GenerateCSVTemplateJob do
  include ActiveSupport::Testing::TimeHelpers
  include Turbo::Broadcastable::TestHelper

  include_context 'with user'

  let(:shard) { :default }

  before { freeze_time }

  it { is_expected.to be_a(Schematics::Shardable) }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(shard, user.id, 'User') }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .with(shard, user.id, 'User')
        .on_queue('default')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(shard, user.id, 'User') }

    let(:stream) do
      capture_turbo_stream_broadcasts([user, :generate_file_in_background]) { perform_now }
    end

    it 'uploads a blob' do
      expect { perform_now }
        .to change(ActiveStorage::Blob, :count)
        .by(1)
    end

    it 'queues the purge job' do
      expect { perform_now }
        .to have_enqueued_job(ActiveStorage::PurgeJob)
        .exactly(:once)
        .with(shard, String)
        .on_queue('low')
        .at(Schematics::Resources::GenerateFile::PURGE_WAIT.from_now)
    end

    it 'broadcasts replace to user' do
      expect(stream.first['action']).to eq('replace')
    end

    it 'broadcasts to user target' do
      expect(stream.first['target']).to eq('generate_file_in_background')
    end
  end
end
