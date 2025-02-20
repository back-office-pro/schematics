# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Options::Icon do
  subject { described_class }

  before do
    allow(YAML)
      .to receive(:load_file)
      .with(File.expand_path('../../../../lib/icons.yml', __dir__))
      .and_return(%w[box users])
  end

  it { is_expected.not_to be_multiple }

  its(:option_name) { is_expected.to eq(:icon) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:collection) { is_expected.to eq(%i[box users]) }
  its(:controller) { is_expected.to eq('dropdowns--fa-icons-dropdown') }
end
