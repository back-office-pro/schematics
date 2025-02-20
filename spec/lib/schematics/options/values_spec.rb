# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Options::Values do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:values) }
  its(:input_type) { is_expected.to eq(:array) }
end
