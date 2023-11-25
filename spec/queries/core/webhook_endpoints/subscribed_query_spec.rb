# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::WebhookEndpoints::SubscribedQuery do
  subject(:query) { described_class }

  let(:first_webhook_endpoint) do
    WebhookEndpoint.create!(
      url: 'https://www.nowhere.com/1',
      subscriptions: ['user.created']
    )
  end
  let(:second_webhook_endpoint) do
    WebhookEndpoint.create!(
      url: 'https://www.nowhere.com/2',
      subscriptions: ['user.updated']
    )
  end

  before { [first_webhook_endpoint, second_webhook_endpoint] }

  describe '.call' do
    subject { query.call(event) }

    context 'when event is user.created' do
      let(:event) { 'user.created' }

      it { is_expected.to contain_exactly(first_webhook_endpoint) }
    end

    context 'when event is user.updated' do
      let(:event) { 'user.updated' }

      it { is_expected.to contain_exactly(second_webhook_endpoint) }
    end

    context 'when event is user.destroyed' do
      let(:event) { 'user.destroyed' }

      it { is_expected.to be_empty }
    end
  end
end
