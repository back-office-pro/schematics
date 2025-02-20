# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Options::InverseAssociationName do
  subject { described_class }

  it { is_expected.to be_hidden }

  its(:option_name) { is_expected.to eq(:inverse_association_name) }
  its(:input_type) { is_expected.to eq(:string) }
end
