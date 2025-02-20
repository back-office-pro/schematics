# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Options::DependsOn do
  subject { described_class }

  it { is_expected.to be_hidden }

  its(:option_name) { is_expected.to eq(:depends_on) }
  its(:input_type) { is_expected.to eq(:string) }
end
