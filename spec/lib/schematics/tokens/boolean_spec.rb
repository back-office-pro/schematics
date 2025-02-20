# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Tokens::Boolean do
  subject(:token) { described_class.new(value) }

  let(:value) { 'true' }

  its(:to_sql) { is_expected.to eq('TRUE') }
  its(:to_str) { is_expected.to eq('true') }
end
