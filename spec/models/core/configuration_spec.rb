# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Configuration do
  include Schematics::Specs::Model

  before do
    allow(BootstrapEmail).to receive(:clear_sass_cache!).and_return(nil)
  end

  after do
    ActiveStorage::Blob.service = ActiveStorage::Blob.services.fetch(:test)
  end

  it 'clears bootstrap email cache after update' do
    record.tap(&:save!).update!(theme_color: '#ffffff')
    expect(BootstrapEmail).to have_received(:clear_sass_cache!)
  end

  it 'updates the storage service after update' do
    expect { record.tap(&:save!).update!(aws_bucket: 'test') }
      .to change { ActiveStorage::Blob.service.name }
      .from(:test)
      .to(:amazon)
  end

  describe '.time_zone_with_fallback' do
    subject { described_class.time_zone_with_fallback }

    it { is_expected.to eq('UTC') }
  end

  describe '.gcloud_public_api_key_with_fallback' do
    subject { described_class.gcloud_public_api_key_with_fallback }

    it { is_expected.to be_a(String) }
  end

  describe '.default_url_options' do
    subject { described_class.default_url_options }

    it { is_expected.to eq(host: 'localhost', port: 3000) }
  end

  describe '.allowed_sources' do
    subject { described_class.allowed_sources }

    it { is_expected.to be_empty }
  end
end
