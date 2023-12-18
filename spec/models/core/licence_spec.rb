# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Licence do
  include Schematics::Specs::Model

  include_context 'with stripe stubs'

  let(:metadata) do
    {
      users: 3,
      api_keys: 2,
      databases: 1,
      storage: 1,
      entities: 1,
      support: 1
    }
  end

  before do
    record.metadata = metadata
  end

  it { is_expected.not_to be_quota_users_exceeded }
  it { is_expected.not_to be_quota_api_keys_exceeded }
  it { is_expected.not_to be_email_support }
  it { is_expected.to be_live_support }

  its(:quota_entities_percentage) { is_expected.to be_zero }
  its(:quota_storage_percentage) { is_expected.to be_zero }
  its(:quota_users_percentage) { is_expected.to be_zero }
  its(:quota_api_keys_percentage) { is_expected.to be_zero }

  its(:entities_size) { is_expected.to be_zero }
  its(:storage_size) { is_expected.to be_zero }
  its(:users_size) { is_expected.to be_zero }
  its(:api_keys_size) { is_expected.to be_zero }

  its(:quota) { is_expected.to be_a(Data) }
  its(:quota) { is_expected.to have_attributes(**metadata) }

  its(:quota_users) { is_expected.to eq(3) }
  its(:quota_api_keys) { is_expected.to eq(2) }
  its(:quota_databases) { is_expected.to eq(1) }
  its(:quota_storage) { is_expected.to eq(1.gigabyte) }
  its(:quota_entities) { is_expected.to eq(1) }

  it 'sends a gateway request after enable' do
    record.tap(&:cancel!).enable!
    expect(subscription_stub_request).to have_been_requested.twice
  end

  it 'sends a gateway request after cancel' do
    record.cancel!
    expect(subscription_stub_request).to have_been_requested.once
  end

  describe '#quota_storage_will_be_exceeded?' do
    subject { record.quota_storage_will_be_exceeded?(size) }

    context 'when size is greater than storage quota' do
      let(:size) { 2.gigabytes }

      it { is_expected.to be_truthy }
    end

    context 'when size is lower than storage quota' do
      let(:size) { 2.bytes }

      it { is_expected.to be_falsy }
    end
  end

  describe '#load!' do
    subject(:load!) { record.load! }

    before do
      allow(record).to receive(:update_env_file).and_return(nil)
    end

    it 'updates licence metadata' do
      expect { load! }
        .to change(record, :metadata)
        .from(metadata.stringify_keys)
        .to(new_metadata.stringify_keys)
    end

    it 'updates licence plan' do
      expect { load! }
        .to change(record, :plan)
        .from('basic')
        .to('premium')
    end

    it 'updates .env file' do
      load!
      expect(record).to have_received(:update_env_file)
    end
  end
end
