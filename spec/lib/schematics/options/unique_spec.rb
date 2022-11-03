# frozen_string_literal: true

describe Schematics::Options::Unique do
  subject { described_class }

  its(:name) { is_expected.to eq(:unique) }
  its(:input_type) { is_expected.to eq(:boolean) }
end
