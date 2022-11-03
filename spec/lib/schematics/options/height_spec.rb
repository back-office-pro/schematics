# frozen_string_literal: true

describe Schematics::Options::Height do
  subject { described_class }

  its(:name) { is_expected.to eq(:height) }
  its(:input_type) { is_expected.to eq(:integer) }
end
