# frozen_string_literal: true

describe Schematics::Options::Inverse do
  subject { described_class }

  it { is_expected.to be_hidden }

  its(:name) { is_expected.to eq(:inverse) }
  its(:input_type) { is_expected.to eq(:string) }
end
