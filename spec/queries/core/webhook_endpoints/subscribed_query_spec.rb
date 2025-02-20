# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::WebhookEndpoints::SubscribedQuery do
  subject(:query) { described_class }

  let(:first_event) { Permission.create!(model: 'User', action: 'create') }
  let(:second_event) { Permission.create!(model: 'User', action: 'update') }
  let(:third_event) { Permission.create!(model: 'User', action: 'destroy') }
  let(:first_webhook_endpoint) do
    WebhookEndpoint.create!(
      url: 'https://www.nowhere.com/1',
      events: [first_event]
    )
  end
  let(:second_webhook_endpoint) do
    WebhookEndpoint.create!(
      url: 'https://www.nowhere.com/2',
      events: [second_event]
    )
  end

  before do
    first_event
    second_event
    third_event
    first_webhook_endpoint
    second_webhook_endpoint
  end

  describe '.call' do
    subject { query.call(event) }

    context 'when event is user create' do
      let(:event) { first_event }

      it { is_expected.to contain_exactly(first_webhook_endpoint) }
    end

    context 'when event is user update' do
      let(:event) { second_event }

      it { is_expected.to contain_exactly(second_webhook_endpoint) }
    end

    context 'when event is user destroy' do
      let(:event) { third_event }

      it { is_expected.to be_empty }
    end
  end
end
