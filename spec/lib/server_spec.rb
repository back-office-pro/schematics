# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_support/core_ext/string/inquiry'
require 'rails'

describe Server do
  subject { described_class }

  before { allow(Rails).to receive(:env).and_return(environment.inquiry) }

  context 'when environment is development' do
    let(:environment) { 'development' }

    it { is_expected.not_to be_ssl }

    its(:domain) { is_expected.to eq('back-office.pro') }
    its(:url) { is_expected.to eq('https://www.back-office.pro') }
    its(:ssl_path) { is_expected.to eq(Pathname.new('/etc/letsencrypt/live/back-office.pro')) }
    its(:port) { is_expected.to eq(3000) }
  end

  context 'when environment is production' do
    let(:environment) { 'production' }

    its(:port) { is_expected.to be_nil }
  end
end
