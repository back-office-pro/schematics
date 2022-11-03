# frozen_string_literal: true

describe Schematics::Options::Readonly do
  subject { described_class }

  its(:name) { is_expected.to eq(:readonly) }
  its(:input_type) { is_expected.to eq(:boolean) }
end
