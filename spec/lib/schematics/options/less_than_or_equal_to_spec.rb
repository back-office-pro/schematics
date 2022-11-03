# frozen_string_literal: true

describe Schematics::Options::LessThanOrEqualTo do
  subject { described_class }

  its(:name) { is_expected.to eq(:less_than_or_equal_to) }
  its(:input_type) { is_expected.to eq(:string) }
end
