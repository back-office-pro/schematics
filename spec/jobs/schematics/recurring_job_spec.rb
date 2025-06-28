# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::RecurringJob do
  let(:job_class) { 'LoadSubscriptionJob' }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(job_class) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .with(job_class)
        .on_queue('default')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(job_class) }

    it 'enqueues a load subscription job for default shard' do
      expect { perform_now }
        .to have_enqueued_job(Schematics::LoadSubscriptionJob)
        .exactly(:once)
        .with(:demo)
        .on_queue('critical')
        .at(:no_wait)
    end
  end
end
