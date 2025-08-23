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

    its(:domain) { is_expected.to eq('localhost') }
  end

  context 'when environment is production' do
    let(:environment) { 'production' }

    it { is_expected.not_to be_ssl }

    its(:domain) { is_expected.to eq('back-office.pro') }
  end
end
