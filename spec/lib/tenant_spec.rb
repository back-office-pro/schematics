# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_support/core_ext/string/inquiry'
require 'rails'

describe Tenant do
  subject { described_class }

  before do
    allow(Rails).to receive(:env).and_return(environment.inquiry)
    allow(Rails.application.class).to receive(:module_parent_name).and_return('demo')
  end

  context 'when environment is development' do
    let(:environment) { 'development' }

    its(:app_name) { is_expected.to eq('demo') }
    its(:default_url_options) { is_expected.to eq(host: 'localhost', port: 3000) }
    its(:database) { is_expected.to eq(:sqlite3) }
  end

  context 'when environment is production' do
    let(:environment) { 'production' }

    its(:app_name) { is_expected.to eq('demo') }
    its(:default_url_options) { is_expected.to eq(host: 'demo.back-office.pro') }
    its(:database) { is_expected.to eq(:sqlite3) }
  end
end
