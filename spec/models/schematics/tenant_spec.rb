# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Tenant do
  subject { described_class.new(subdomain:) }

  context 'when subdomain is blank' do
    let(:subdomain) { '' }

    its(:subdomain) { is_expected.to be_nil }
    its(:default_url_options) { is_expected.to eq(host: 'localhost', port: 3000) }
    it { is_expected.not_to be_demo }
  end

  context 'when subdomain is defined' do
    let(:subdomain) { 'back-office' }

    its(:subdomain) { is_expected.to eq('back-office') }
    its(:default_url_options) { is_expected.to eq(host: 'localhost', port: 3000) }
    it { is_expected.not_to be_demo }
  end
end
