# frozen_string_literal: true

describe Schematics::Options::Type do
  subject { described_class }

  its(:name) { is_expected.to eq(:type) }
  its(:input_type) { is_expected.to eq(:string) }
end
