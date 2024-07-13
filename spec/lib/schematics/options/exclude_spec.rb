# frozen_string_literal: true

describe Schematics::Options::Exclude do
  subject { described_class }

  it { is_expected.to be_hidden }

  its(:option_name) { is_expected.to eq(:exclude) }
  its(:input_type) { is_expected.to eq(:select) }
end
