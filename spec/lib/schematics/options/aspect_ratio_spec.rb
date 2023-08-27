# frozen_string_literal: true

describe Schematics::Options::AspectRatio do
  subject { described_class }

  it { is_expected.not_to be_multiple }

  its(:name) { is_expected.to eq(:aspect_ratio) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:collection) { is_expected.to eq(%i[landscape square is_16_9 is_4_3]) } # rubocop:disable Naming/VariableNumber
  its(:controller) { is_expected.to eq('dropdown') }
end
