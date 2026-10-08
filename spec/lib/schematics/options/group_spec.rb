# frozen_string_literal: true

describe Schematics::Options::Group do
  subject { described_class }

  it { is_expected.to be_hidden }

  its(:option_name) { is_expected.to eq(:group) }
  its(:input_type) { is_expected.to eq(:string) }
  its(:openai_type) { is_expected.to eq('string') }
end
