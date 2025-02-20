# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Options::InverseAssociationType do
  subject { described_class }

  it { is_expected.not_to be_multiple }

  its(:option_name) { is_expected.to eq(:inverse_association_type) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:collection) { is_expected.to eq([%w[One-to-many has_many], %w[One-to-one has_one]]) }
  its(:controller) { is_expected.to eq('dropdown') }
end
