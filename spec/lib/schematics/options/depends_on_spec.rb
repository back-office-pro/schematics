# frozen_string_literal: true

describe Schematics::Options::DependsOn do
  subject { described_class }

  its(:name) { is_expected.to eq(:depends_on) }
  its(:input_type) { is_expected.to eq(:string) }
end
