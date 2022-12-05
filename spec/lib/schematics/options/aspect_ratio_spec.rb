# frozen_string_literal: true

describe Schematics::Options::AspectRatio do
  subject { described_class }

  its(:name) { is_expected.to eq(:aspect_ratio) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:collection) { is_expected.to eq(%i[landspace square is_16_9 is_4_3]) } # rubocop:disable Naming/VariableNumber

  it { is_expected.not_to be_multiple }
end
