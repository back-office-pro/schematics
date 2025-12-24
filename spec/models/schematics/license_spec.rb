# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::License do
  subject(:license) { described_class.new(email:, expires_at:, signature:) }

  let(:email) { 'support@back-office.pro' }
  let(:expires_at) { 1_798_062_114 }
  let(:signature) { 'test' }

  it { is_expected.not_to be_active }
end
