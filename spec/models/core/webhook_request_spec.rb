# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebhookRequest do
  include Schematics::Specs::Model

  before { record.state_error! }

  its(:body) { is_expected.to match('event' => String, 'payload' => {}) }

  it 'enqueues a trigger webhook job after retry' do
    expect { record.retry! }
      .to have_enqueued_job(Schematics::TriggerWebhookJob)
      .exactly(:once)
      .with(:default, record.id)
      .on_queue('low')
      .at(:no_wait)
  end
end
