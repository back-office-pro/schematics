# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Configuration::Mailer do
  subject { described_class.new(configuration) }

  let(:configuration) do
    Configuration.new(
      postmark_api_token:,
      mailgun_api_key:,
      mailjet_api_key:,
      mailjet_secret_key:
    )
  end

  context 'when not configured' do
    let(:postmark_api_token) { nil }
    let(:mailgun_api_key) { nil }
    let(:mailjet_api_key) { nil }
    let(:mailjet_secret_key) { nil }

    it { is_expected.not_to be_configured }

    its(:delivery_method) { is_expected.to eq(:test) }
    its(:settings) { is_expected.to be_empty }
  end

  context 'when postmark is configured' do
    let(:postmark_api_token) { 'test' }
    let(:mailgun_api_key) { nil }
    let(:mailjet_api_key) { nil }
    let(:mailjet_secret_key) { nil }

    it { is_expected.to be_configured }

    its(:delivery_method) { is_expected.to eq(:postmark) }
    its(:settings) { is_expected.to eq(postmark_settings: { api_token: 'test' }) }
  end

  context 'when mailgun is configured' do
    let(:postmark_api_token) { nil }
    let(:mailgun_api_key) { 'test' }
    let(:mailjet_api_key) { nil }
    let(:mailjet_secret_key) { nil }

    it { is_expected.to be_configured }

    its(:delivery_method) { is_expected.to eq(:mailgun) }
    its(:settings) { is_expected.to eq(mailgun_settings: { api_key: 'test', timeout: 5 }) }
  end

  context 'when mailjet is configured' do
    let(:postmark_api_token) { nil }
    let(:mailgun_api_key) { nil }
    let(:mailjet_api_key) { 'test' }
    let(:mailjet_secret_key) { 'test' }

    it { is_expected.to be_configured }

    its(:delivery_method) { is_expected.to eq(:mailjet) }
    its(:settings) { is_expected.to eq(mailjet_settings: { api_key: 'test', secret_key: 'test' }) }
  end
end
