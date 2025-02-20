# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Tokens::Assignment do
  subject(:token) { described_class.new(value) }

  let(:value) { '+=' }

  its(:to_sql) { is_expected.to eq('+=') }
  its(:to_str) { is_expected.to eq('+=') }
end
