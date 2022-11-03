# frozen_string_literal: true

describe Schematics::Options::Confirm do
  subject { described_class }

  its(:name) { is_expected.to eq(:confirm) }
  its(:input_type) { is_expected.to eq(:boolean) }
end
