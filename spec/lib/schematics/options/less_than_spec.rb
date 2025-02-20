# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Options::LessThan do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:less_than) }
  its(:input_type) { is_expected.to eq(:integer) }
  its(:min) { is_expected.to be_nil }
end
