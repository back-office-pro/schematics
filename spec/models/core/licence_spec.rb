# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Licence do
  include Schematics::Specs::Model

  let(:metadata) { { users: 3, api_keys: 2, databases: 1, storage: 1, entities: 1 } }

  before { record.metadata = metadata }

  it { is_expected.not_to be_quota_entities_exceeded }
  it { is_expected.not_to be_quota_storage_exceeded }
  it { is_expected.not_to be_quota_users_exceeded }
  it { is_expected.not_to be_quota_api_keys_exceeded }

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

  describe 'load!' do
    let(:new_metadata) { { users: 1000, api_keys: 100, databases: 3, storage: 100, entities: 100 } }
    let(:context) { double('context', data: { metadata: new_metadata }) } # rubocop:disable RSpec/VerifiedDoubles

    before do
      allow(described_class::GATEWAY::Fetch).to receive(:call).and_return(context)
      allow(record).to receive(:update_env_file).and_return(nil)
    end

    it 'updates licence metadata' do
      expect { record.load! }
        .to change(record, :metadata)
        .from(metadata.stringify_keys)
        .to(new_metadata.stringify_keys)
    end

    it 'updates .env file' do
      record.load!
      expect(record).to have_received(:update_env_file)
    end
  end
end
