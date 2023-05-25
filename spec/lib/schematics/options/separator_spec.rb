# frozen_string_literal: true

describe Schematics::Options::Separator do
  subject { described_class }

  its(:name) { is_expected.to eq(:separator) }
  its(:input_type) { is_expected.to eq(:string) }
end
