# frozen_string_literal: true

describe Schematics::Options::Limit do
  subject { described_class }

  its(:name) { is_expected.to eq(:limit) }
  its(:input_type) { is_expected.to eq(:integer) }
end
