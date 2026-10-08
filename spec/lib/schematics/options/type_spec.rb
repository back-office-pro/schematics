# frozen_string_literal: true

describe Schematics::Options::Type do
  subject { described_class }

  it { is_expected.to be_hidden }

  its(:option_name) { is_expected.to eq(:type) }
  its(:input_type) { is_expected.to eq(:string) }
  its(:openai_type) { is_expected.to eq('string') }
end
