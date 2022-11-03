# frozen_string_literal: true

describe Schematics::Options::Default do
  subject { described_class }

  its(:name) { is_expected.to eq(:default) }
  its(:input_type) { is_expected.to eq(:string) }
end
