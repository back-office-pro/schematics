# frozen_string_literal: true

describe Schematics::Options::Values do
  subject { described_class }

  its(:name) { is_expected.to eq(:values) }
  its(:input_type) { is_expected.to eq(:array) }
end
