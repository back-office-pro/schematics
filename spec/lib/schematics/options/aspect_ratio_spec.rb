# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Options::AspectRatio do
  subject { described_class }

  it { is_expected.to be_multiple }

  its(:option_name) { is_expected.to eq(:aspect_ratio) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:controller) { is_expected.to eq('dropdown') }

  its(:collection) do
    is_expected.to eq(
      [
        %w[16/9 is_16_9],
        %w[4/3 is_4_3],
        %w[Landscape landscape],
        %w[Square square]
      ]
    )
  end
end
