# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Options::Width do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:width) }
  its(:input_type) { is_expected.to eq(:integer) }
  its(:min) { is_expected.to be_zero }
end
