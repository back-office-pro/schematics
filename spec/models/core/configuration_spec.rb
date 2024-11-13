# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Configuration do
  include Schematics::Specs::Model

  before do
    allow(BootstrapEmail).to receive(:clear_sass_cache!).and_return(nil)
    BootstrapEmail.static_config.sass_email_string = nil
  end

  it 'clears bootstrap email cache after update' do
    record.tap(&:save!).update!(theme_color: '#ffffff')
    expect(BootstrapEmail).to have_received(:clear_sass_cache!)
  end

  it 'updates bootstrap email config after update' do
    expect { record.tap(&:save!).update!(theme_color: '#ffffff') }
      .to change(BootstrapEmail.static_config, :sass_email_string)
      .from(nil)
      .to("$primary: #ffffff;\n@import 'bootstrap-email';\n")
  end

  describe '.time_zone_with_fallback' do
    subject { described_class.time_zone_with_fallback }

    it { is_expected.to eq('UTC') }
  end

  describe '.openai_access_token_with_fallback' do
    subject { described_class.openai_access_token_with_fallback }

    it { is_expected.to be_a(String) }
  end

  describe '.gcloud_api_key_with_fallback' do
    subject { described_class.gcloud_api_key_with_fallback }

    it { is_expected.to be_a(String) }
  end
end
