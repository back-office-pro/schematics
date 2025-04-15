# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_support/core_ext/string/inquiry'
require 'rails'

describe Tenant do
  subject { described_class }

  before { allow(Rails).to receive(:env).and_return(environment.inquiry) }

  context 'when environment is development' do
    let(:environment) { 'development' }

    it { is_expected.to be_demo }

    its(:database_name) { is_expected.to eq('demo') }
    its(:default_url_options) { is_expected.to eq(host: 'localhost', port: 3000) }
  end

  context 'when environment is production' do
    let(:environment) { 'production' }

    it { is_expected.to be_demo }

    its(:database_name) { is_expected.to eq('demo') }
    its(:default_url_options) { is_expected.to eq(host: 'demo.back-office.pro') }
  end

  context 'when environment is test' do
    let(:environment) { 'test' }

    it { is_expected.not_to be_demo }

    its(:database_name) { is_expected.to eq('demo') }
    its(:default_url_options) { is_expected.to eq(host: 'localhost', port: 3000) }
  end
end
