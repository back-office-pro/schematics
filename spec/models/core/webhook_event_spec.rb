# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebhookEvent do
  include Schematics::Specs::Model

  before { record.state_error! }

  it 'enqueues a webhook job after retry' do
    expect { record.retry! }
      .to have_enqueued_job(Schematics::WebhookJob)
      .with(record)
  end
end
