# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Version do
  subject(:version) { described_class.new(event:, item:, user:, object:) }

  include_context 'with user'

  let(:webhook_endpoint) do
    WebhookEndpoint.create!(
      url: 'https://www.nowhere.com',
      events: [Permission.create!(model: 'User', action: 'update')]
    )
  end

  before { webhook_endpoint }

  let(:event) { 'update' }
  let(:item) { user }
  let(:object) { user.as_json }

  its(:model_class) { is_expected.to eq(User) }
  its(:icon) { is_expected.to eq(:pen_to_square) }

  its(:serialized_json) do
    is_expected.to include(:event, :id, :createdAt, :item, :user, :objectChanges)
  end

  it 'enqueues a webhook job after create' do
    expect { version.save! }
      .to have_enqueued_job(Schematics::WebhookJob)
      .with(WebhookRequest)
      .on_queue('webhooks')
  end
end
