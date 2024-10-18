# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Configuration do
  include Schematics::Specs::Model

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
