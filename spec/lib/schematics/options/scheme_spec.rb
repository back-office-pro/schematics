# frozen_string_literal: true

describe Schematics::Options::Scheme do
  subject { described_class }

  it { is_expected.to be_multiple }

  its(:name) { is_expected.to eq(:scheme) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:controller) { is_expected.to eq('dropdown') }
  its(:collection) { is_expected.to eq(%w[http https]) }
end
