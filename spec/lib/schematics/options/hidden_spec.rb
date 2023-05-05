# frozen_string_literal: true

describe Schematics::Options::Hidden do
  subject { described_class }

  it { is_expected.to be_hidden }

  its(:name) { is_expected.to eq(:hidden) }
  its(:input_type) { is_expected.to eq(:boolean) }
end
