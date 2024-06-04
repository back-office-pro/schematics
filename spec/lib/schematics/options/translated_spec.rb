# frozen_string_literal: true

describe Schematics::Options::Translated do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:translated) }
  its(:input_type) { is_expected.to eq(:boolean) }
end
