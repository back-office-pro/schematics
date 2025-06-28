# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::BulkActionJob do
  include_context 'with user'

  let(:shard) { :default }
  let(:model_name) { 'User' }
  let(:ids) { [user.id] }

  it { is_expected.to be_a(Schematics::Shardable) }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(shard, user.id, model_name, ids) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .on_queue('default')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(shard, user.id, model_name, ids) }

    it 'archives records' do
      expect { perform_now }.to change(User, :count).by(-ids.size)
    end
  end
end
