# frozen_string_literal: true

describe Schematics::Options::GreaterThanOrEqualTo do
  subject { described_class }

  its(:name) { is_expected.to eq(:greater_than_or_equal_to) }
  its(:input_type) { is_expected.to eq(:string) }
end
