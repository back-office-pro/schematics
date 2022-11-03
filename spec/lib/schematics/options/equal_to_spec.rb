# frozen_string_literal: true

describe Schematics::Options::EqualTo do
  subject { described_class }

  its(:name) { is_expected.to eq(:equal_to) }
  its(:input_type) { is_expected.to eq(:string) }
end
