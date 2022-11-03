# frozen_string_literal: true

describe Schematics::Options::Hidden do
  subject { described_class }

  its(:name) { is_expected.to eq(:hidden) }
  its(:input_type) { is_expected.to eq(:boolean) }
end
