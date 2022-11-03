# frozen_string_literal: true

describe Schematics::Options::Polymorphic do
  subject { described_class }

  its(:name) { is_expected.to eq(:polymorphic) }
  its(:input_type) { is_expected.to eq(:boolean) }
end
