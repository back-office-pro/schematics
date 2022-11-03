# frozen_string_literal: true

describe Schematics::Options::Width do
  subject { described_class }

  its(:name) { is_expected.to eq(:width) }
  its(:input_type) { is_expected.to eq(:integer) }
end
