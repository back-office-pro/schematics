# frozen_string_literal: true

describe Schematics::Options::Cached do
  subject { described_class }

  its(:name) { is_expected.to eq(:cached) }
  its(:input_type) { is_expected.to eq(:boolean) }
end
