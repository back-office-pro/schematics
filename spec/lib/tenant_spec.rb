# frozen_string_literal: true

require 'active_support/core_ext/string/inquiry'
require 'rails'

describe Tenant do
  subject { described_class }

  before do
    allow(Rails).to receive(:env).and_return(environment.inquiry)
    allow(Rails.application.class).to receive(:module_parent_name).and_return(app_name)
  end

  context 'when environment is development and in demo application' do
    let(:environment) { 'development' }
    let(:app_name) { 'Demo' }

    it { is_expected.to be_demo }

    its(:app_name) { is_expected.to eq('demo') }
    its(:default_url_options) { is_expected.to eq(host: 'localhost', port: 3000) }
    its(:default_mailer_options) { is_expected.to eq(from: 'no-reply@localhost') }
    its(:database) { is_expected.to eq(:sqlite3) }
  end

  context 'when environment is production and in demo application' do
    let(:environment) { 'production' }
    let(:app_name) { 'Demo' }

    it { is_expected.to be_demo }

    its(:default_url_options) { is_expected.to eq(host: 'demo.back-office.pro') }
  end

  context 'when environment is development and not in demo application' do
    let(:environment) { 'development' }
    let(:app_name) { 'BackOffice' }

    it { is_expected.not_to be_demo }
  end
end
