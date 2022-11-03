# frozen_string_literal: true

describe Schematics::Options::Scale do
  subject { described_class }

  its(:name) { is_expected.to eq(:scale) }
  its(:input_type) { is_expected.to eq(:integer) }
end
