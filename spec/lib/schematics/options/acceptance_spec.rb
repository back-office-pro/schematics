# frozen_string_literal: true

describe Schematics::Options::Acceptance do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:acceptance) }
  its(:input_type) { is_expected.to eq(:boolean) }
end
