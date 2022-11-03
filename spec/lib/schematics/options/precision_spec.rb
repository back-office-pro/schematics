# frozen_string_literal: true

describe Schematics::Options::Precision do
  subject { described_class }

  its(:name) { is_expected.to eq(:precision) }
  its(:input_type) { is_expected.to eq(:integer) }
end
