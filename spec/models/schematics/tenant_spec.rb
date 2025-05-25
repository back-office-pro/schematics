# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Tenant do
  subject { described_class.new(subdomain:) }

  let(:subdomain) { 'demo' }

  its(:subdomain) { is_expected.to eq('demo') }
  its(:default_url_options) { is_expected.to eq(host: 'demo.localhost.me', port: 3000) }
  it { is_expected.not_to be_demo }
end
