# frozen_string_literal: true

describe Tenant do
  subject(:tenant) { described_class }

  it { is_expected.not_to be_ssl }

  its(:schema) { is_expected.to be_a(Schematics::Schema) }
  its(:search_engine) { is_expected.to be_a(SearchEngine::Postgresql) }
  its(:domain) { is_expected.to eq('back-office.pro') }
  its(:organization) { is_expected.to eq('back-office-pro') }
  its(:ssl_path) { is_expected.to eq(Pathname.new('/etc/letsencrypt/live/back-office.pro')) }
  its(:version) { is_expected.to eq('1.0.0') }
end
