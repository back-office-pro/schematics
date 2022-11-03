# frozen_string_literal: true

describe Schematics::Options::Size do
  subject { described_class }

  its(:name) { is_expected.to eq(:size) }
  its(:input_type) { is_expected.to eq(:integer) }
end
