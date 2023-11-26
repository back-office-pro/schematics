# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebhookEvent do
  include Schematics::Specs::Model

  before do
    record.state_error!
    stub_request(:post, record.webhook_endpoint.url).to_return(status: 200)
  end

  it 'enqueues a webhook job after retry' do
    expect { record.retry! }
      .to have_enqueued_job(Schematics::WebhookJob)
      .with(record)
  end

  its(:response) { is_expected.to be_a(Net::HTTPOK) }
end
