# frozen_string_literal: true

describe Schematics::Options::CaseInsensitive do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:case_insensitive) }
  its(:input_type) { is_expected.to eq(:boolean) }
end
