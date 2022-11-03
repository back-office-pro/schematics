# frozen_string_literal: true

describe Schematics::Options::Required do
  subject { described_class }

  its(:name) { is_expected.to eq(:required) }
  its(:input_type) { is_expected.to eq(:boolean) }
end
