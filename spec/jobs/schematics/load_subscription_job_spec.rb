# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::LoadSubscriptionJob do
  let(:subscription) { Subscription.instance.tap(&:save!) }

  it { is_expected.to be_a(Schematics::MultiShardable) }
  it { is_expected.to be_a(Schematics::Quietable) }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .on_queue('critical')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    include_context 'with stripe stubs'

    it 'loads subscription from gateway' do
      expect { described_class.perform_now }.to(change { subscription.reload.metadata })
    end
  end
end
