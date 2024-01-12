# frozen_string_literal: true

describe Schematics::Options::Separator do
  subject { described_class }

  it { is_expected.not_to be_multiple }

  its(:name) { is_expected.to eq(:separator) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:controller) { is_expected.to eq('dropdown') }
  its(:collection) { is_expected.to eq(%w[, .]) }
end
