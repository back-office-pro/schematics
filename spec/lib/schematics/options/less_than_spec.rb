# frozen_string_literal: true

describe Schematics::Options::LessThan do
  subject { described_class }

  its(:name) { is_expected.to eq(:less_than) }
  its(:input_type) { is_expected.to eq(:string) }
end
