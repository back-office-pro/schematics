# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Configuration do
  include Schematics::Specs::Model

  before do
    allow(Rails.env).to receive(:on_premise?).and_return(true)
  end

  after do
    ActiveStorage::Blob.service = ActiveStorage::Blob.services.fetch(:test)
  end

  it 'updates the storage service after update' do
    expect { record.tap(&:save!).update!(aws_access_key_id: 'test') }
      .to change { ActiveStorage::Blob.service.name }
      .from(:test)
      .to(:amazon)
  end

  describe '.time_zone_with_fallback' do
    subject { described_class.time_zone_with_fallback }

    it { is_expected.to eq('UTC') }
  end

  describe '.openai_access_token_with_fallback' do
    subject { described_class.openai_access_token_with_fallback }

    it { is_expected.to be_a(String) }
  end

  describe '.gcloud_public_api_key_with_fallback' do
    subject { described_class.gcloud_public_api_key_with_fallback }

    it { is_expected.to be_a(String) }
  end

  describe '.gcloud_private_api_key_with_fallback' do
    subject { described_class.gcloud_private_api_key_with_fallback }

    it { is_expected.to be_a(String) }
  end
end
