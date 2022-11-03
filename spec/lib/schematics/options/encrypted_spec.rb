# frozen_string_literal: true

describe Schematics::Options::Encrypted do
  subject { described_class }

  its(:name) { is_expected.to eq(:encrypted) }
  its(:input_type) { is_expected.to eq(:boolean) }
end
