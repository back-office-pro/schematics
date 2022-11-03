# frozen_string_literal: true

describe Schematics::Options::OtherThan do
  subject { described_class }

  its(:name) { is_expected.to eq(:other_than) }
  its(:input_type) { is_expected.to eq(:string) }
end
