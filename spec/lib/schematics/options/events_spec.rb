# frozen_string_literal: true

describe Schematics::Options::Events do
  subject { described_class }

  its(:name) { is_expected.to eq(:events) }
  its(:input_type) { is_expected.to eq(:events) }
end
