# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Options::Schemes do
  subject { described_class }

  it { is_expected.to be_multiple }

  its(:option_name) { is_expected.to eq(:schemes) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:controller) { is_expected.to eq('dropdown') }
  its(:collection) { is_expected.to eq(%w[http https]) }
end
