# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription do
  include Schematics::Specs::Model

  include_context 'with stripe stubs'

  let(:metadata) do
    {
      users: 3,
      api_keys: 2
    }
  end

  before do
    record.metadata = metadata
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

  describe '.quota_api_keys_exceeded?' do
    subject { described_class.quota_api_keys_exceeded? }

    it { is_expected.to be_falsy }
  end

  describe '.quota_users_exceeded?' do
    subject { described_class.quota_users_exceeded? }

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
end
