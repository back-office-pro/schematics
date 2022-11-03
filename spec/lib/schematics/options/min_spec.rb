# frozen_string_literal: true

describe Schematics::Options::Min do
  subject { described_class }

  its(:name) { is_expected.to eq(:min) }
  its(:input_type) { is_expected.to eq(:integer) }
end
