# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Configuration do
  include Schematics::Specs::Model

  before do
    allow(BootstrapEmail).to receive(:clear_sass_cache!).and_return(nil)
    allow(described_class).to receive(:license).and_call_original
  end

  after do
    ActiveStorage::Blob.service = ActiveStorage::Blob.services.fetch(:test)
    Rails.configuration.action_mailer.delivery_method = :test
  end

  it 'clears bootstrap email cache after update' do
    record.tap(&:save!).reload.update!(theme_color: '#ffffff')
    expect(BootstrapEmail).to have_received(:clear_sass_cache!)
  end

  it 'updates the storage service after update' do
    expect { record.tap(&:save!).reload.update!(aws_bucket: 'test') }
      .to change { ActiveStorage::Blob.service.name }
      .from(:test)
      .to(:amazon)
  end

  it 'updates the mailer delivery method after update' do
    expect { record.tap(&:save!).reload.update!(postmark_api_token: 'test') }
      .to change { Rails.configuration.action_mailer.delivery_method }
      .from(:test)
      .to(:postmark)
  end

  describe '.time_zone_with_fallback' do
    subject { described_class.time_zone_with_fallback }

    it { is_expected.to eq('UTC') }
  end

  describe '.host' do
    subject { described_class.host }

    it { is_expected.to eq('localhost') }
  end

  describe '.default_url_options' do
    subject { described_class.default_url_options }

    it { is_expected.to eq(host: 'localhost', port: 3000) }
  end

  describe '.allowed_sources' do
    subject { described_class.allowed_sources }

    it { is_expected.to be_empty }
  end

  describe '.license' do
    subject { described_class.license }

    it { is_expected.to be_a(Schematics::License) }
  end

  describe '.license_file' do
    subject { described_class.license_file }

    it { is_expected.to be_nil }
  end

  describe '.openai_configured?' do
    subject { described_class.openai_configured? }

    it { is_expected.to be_falsy }
  end

  describe '.openai_access_token' do
    subject { described_class.openai_access_token }

    it { is_expected.to be_nil }
  end

  describe '.openai_uri_base' do
    subject { described_class.openai_uri_base }

    it { is_expected.to be_nil }
  end

  describe '.openai_model' do
    subject { described_class.openai_model }

    it { is_expected.to be_nil }
  end
end
