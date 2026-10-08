# frozen_string_literal: true

describe Schematics::Options::Parent do
  subject { described_class.new(collection:) }

  let(:collection) { %w[portfolio investment instrument] }

  it { is_expected.not_to be_multiple }

  its(:option_name) { is_expected.to eq(:parent) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:collection) { is_expected.to eq(%w[portfolio investment instrument]) }
  its(:controller) { is_expected.to eq('schema-editor--parent-dropdown') }
end
