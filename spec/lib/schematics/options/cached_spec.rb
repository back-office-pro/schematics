# frozen_string_literal: true

describe Schematics::Options::Cached do
  subject { described_class }

  it { is_expected.to be_hidden }

  its(:option_name) { is_expected.to eq(:cached) }
  its(:input_type) { is_expected.to eq(:boolean) }
  its(:openai_type) { is_expected.to eq('boolean') }
end
