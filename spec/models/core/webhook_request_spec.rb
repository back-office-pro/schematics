# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebhookRequest do
  include Schematics::Specs::Model

  before { record.state_error! }

  its(:body) { is_expected.to match('event' => String, 'payload' => {}) }

  it 'enqueues a webhook job after retry' do
    expect { record.retry! }
      .to have_enqueued_job(Schematics::WebhookJob)
      .exactly(:once)
      .with(record)
      .on_queue('webhooks')
      .at(:no_wait)
  end
end
