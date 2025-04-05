# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription do
  include Schematics::Specs::Model

  include_context 'with stripe stubs'

  let(:metadata) do
    {
      users: 3,
      api_keys: 2,
      storage: 1,
      entities: 1,
      prompts: 100,
      support: 1
    }
  end

  before do
    record.metadata = metadata
  end

  it 'sends a gateway request after enable' do
    record.tap(&:cancel!).enable!
    expect(subscription_stub_request).to have_been_requested.twice
  end

  it 'sends a gateway request after cancel' do
    record.cancel!
    expect(subscription_stub_request).to have_been_requested.once
  end

  describe '#load!' do
    subject(:load!) { record.load! }

    it 'updates subscription metadata' do
      expect { load! }
        .to change(record, :metadata)
        .from(metadata.stringify_keys)
        .to(new_metadata.stringify_keys)
    end

    it 'updates subscription plan' do
      expect { load! }
        .to change(record, :plan)
        .from('basic')
        .to('premium')
    end
  end

  describe '.quota_storage_will_be_exceeded?' do
    subject { described_class.quota_storage_will_be_exceeded?(size) }

    context 'when size is greater than storage quota' do
      let(:size) { 2.gigabytes }

      it { is_expected.to be_truthy }
    end

    context 'when size is lower than storage quota' do
      let(:size) { 2.bytes }

      it { is_expected.to be_falsy }
    end
  end

  describe '.quota_api_keys_exceeded?' do
    subject { described_class.quota_api_keys_exceeded? }

    it { is_expected.to be_falsy }
  end

  describe '.quota_users_exceeded?' do
    subject { described_class.quota_users_exceeded? }

    it { is_expected.to be_falsy }
  end

  describe '.quota_prompts_exceeded?' do
    subject { described_class.quota_prompts_exceeded? }

    it { is_expected.to be_falsy }
  end

  describe '.email_support?' do
    subject { described_class.email_support? }

    it { is_expected.to be_truthy }
  end

  describe '.live_support?' do
    subject { described_class.live_support? }

    it { is_expected.to be_falsy }
  end

  describe '.quota_users' do
    subject { described_class.quota_users }

    it { is_expected.to eq(3) }
  end

  describe '.quota_api_keys' do
    subject { described_class.quota_api_keys }

    it { is_expected.to eq(3) }
  end

  describe '.quota_storage' do
    subject { described_class.quota_storage }

    it { is_expected.to eq(1.gigabyte) }
  end

  describe '.quota_entities' do
    subject { described_class.quota_entities }

    it { is_expected.to eq(10) }
  end

  describe '.quota_prompts' do
    subject { described_class.quota_prompts }

    it { is_expected.to eq(100) }
  end
end
