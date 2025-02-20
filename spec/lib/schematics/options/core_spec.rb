# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Options::Core do
  subject { described_class }

  it { is_expected.to be_hidden }

  its(:option_name) { is_expected.to eq(:core) }
  its(:input_type) { is_expected.to eq(:boolean) }
end
