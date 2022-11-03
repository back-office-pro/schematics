# frozen_string_literal: true

describe Schematics::Options::Max do
  subject { described_class }

  its(:name) { is_expected.to eq(:max) }
  its(:input_type) { is_expected.to eq(:integer) }
end
