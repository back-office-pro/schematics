# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::MigrateCoreJob do
  let(:shard) { :default }

  it { is_expected.to be_a(Schematics::Shardable) }
  it { is_expected.to be_a(Schematics::Quietable) }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(shard) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .on_queue('critical')
        .at(:no_wait)
    end
  end
end
