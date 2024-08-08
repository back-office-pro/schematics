# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebhookRequest do
  include Schematics::Specs::Model

  before do
    record.state_error!
    stub_request(:get, record.webhook_endpoint.url).to_return(body: '{}', status: 200)
  end

  it 'enqueues a webhook job after retry' do
    expect { record.retry! }
      .to have_enqueued_job(Schematics::WebhookJob)
      .exactly(:once)
      .with(record)
      .on_queue('webhooks')
      .at(:no_wait)
  end

  its(:response) { is_expected.to be_a(Net::HTTPOK) }
  its(:parsed_response_body) { is_expected.to be_empty }
end
