# frozen_string_literal: true

describe Schematics::Options::Unit do
  subject { described_class }

  its(:name) { is_expected.to eq(:unit) }
  its(:input_type) { is_expected.to eq(:string) }
end
