# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Options::Unit do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:unit) }
  its(:input_type) { is_expected.to eq(:string) }
end
