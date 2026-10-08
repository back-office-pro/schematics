# frozen_string_literal: true

describe Schematics::Options::Actions do
  subject { described_class.new(collection:) }

  let(:collection) { %w[index create] }

  it { is_expected.to be_multiple }

  its(:option_name) { is_expected.to eq(:actions) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:collection) { is_expected.to eq([%w[Add create], %w[List index]]) }
  its(:controller) { is_expected.to eq('dropdown') }
end
