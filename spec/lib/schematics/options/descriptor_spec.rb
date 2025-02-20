# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Options::Descriptor do
  subject { described_class.new(collection:) }

  let(:collection) { %w[id first_name last_name] }

  it { is_expected.not_to be_multiple }

  its(:option_name) { is_expected.to eq(:descriptor) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:collection) { is_expected.to eq(%w[id first_name last_name]) }
  its(:controller) { is_expected.to eq('schema-editor--descriptor-dropdown') }
end
