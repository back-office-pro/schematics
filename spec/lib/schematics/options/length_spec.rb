# frozen_string_literal: true

describe Schematics::Options::Length do
  subject { described_class }

  its(:name) { is_expected.to eq(:length) }
  its(:input_type) { is_expected.to eq(:integer) }
end
