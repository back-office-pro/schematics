# frozen_string_literal: true

describe Instance do
  subject { described_class }

  it { is_expected.not_to be_ssl }

  its(:domain) { is_expected.to eq('back-office.pro') }
  its(:url) { is_expected.to eq('https://www.back-office.pro') }
  its(:support_email) { is_expected.to eq('support@back-office.pro') }
  its(:organization) { is_expected.to eq('back-office-pro') }
  its(:ssl_path) { is_expected.to eq(Pathname.new('/etc/letsencrypt/live/back-office.pro')) }
end
